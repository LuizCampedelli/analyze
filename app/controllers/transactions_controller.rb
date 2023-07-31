# app/controllers/transactions_controller.rb
class TransactionsController < ApplicationController
  def index
    latest_batch_id = Transaction.maximum(:batch_id)
    @transactions = Transaction.where(batch_id: latest_batch_id)

    @anomalies = @transactions.where(status: ['reversed', 'failed', 'backend_reversed'])
    @anomalous_transactions = @anomalies.group_by_hour_of_day(:created_at).sum(:quantity)

    @alert_transactions = @transactions.where(status: 'denied').where.not(id: @anomalies.pluck(:id))
    @alert_transactions_count = @alert_transactions.group_by_hour_of_day(:created_at).sum(:quantity)

    @approved_transactions = @transactions.where(status: 'approved')
    @approved_transactions_count = @approved_transactions.group_by_hour_of_day(:created_at).sum(:quantity)

    @processing_transactions = Transaction.where(status: 'processing')
    @processing_transactions_count = @processing_transactions.group_by_hour_of_day(:created_at).sum(:quantity)
  end

  def create
    @transaction = Transaction.create(transaction_params)
    if transaction.save
      transaction.check_for_anomaly
      render json: {
        status: transaction.status,
        time: transaction.timestamp.strftime("%Y-%m-%d %H:%M:%S"),
      }, status: :created
    else
      render json: transaction.errors, status: :unprocessable_entity
    end
  end

  def import
    if params[:file].present?
      file_data = params[:file].read

      # Pass the file data to the job
      TransactionImportJob.perform_later(file_data)

      # Send email after queuing the import job
      AnalyzeMailer.transactions_analysis_complete.deliver_now

      redirect_to transactions_url, notice: "Transactions imported."
    else
      redirect_to transactions_url, alert: "No file selected."
    end
  end


  # def import
  #   if params[:file].present?
  #     # Generate a unique filename
  #     filename = "#{Time.now.to_i}_#{params[:file].original_filename}"

  #     # Define a directory to store the file
  #     directory = "public/uploads"

  #     # Create the directory if it doesn't exist
  #     Dir.mkdir(directory) unless File.exist?(directory)

  #     # Create a path to the new file in the directory
  #     path = File.join(directory, filename)

  #     # Write the uploaded file's contents to the new file
  #     File.open(path, "wb") { |f| f.write(params[:file].read) }

  #     # Pass the path of the saved file to the job
  #     TransactionImportJob.perform_later(path)

  #     # Send email after queuing the import job
  #     AnalyzeMailer.transactions_analysis_complete.deliver_now

  #     redirect_to transactions_url, notice: "Transactions imported."
  #   else
  #     redirect_to transactions_url, alert: "No file selected."
  #   end
  # end

  private

  def transaction_params
    params.require(:transaction).permit(:file, :status, :timestamp, :quantity, :amount, :batch_id)
  end
end
