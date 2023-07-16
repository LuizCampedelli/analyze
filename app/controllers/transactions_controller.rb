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
    head :ok # This returns an empty response with a 200 OK status
  end

  def import
    if params[:file].present?
      Transaction.import(params[:file])
      redirect_to transactions_url, notice: "Transactions imported."
    else
      redirect_to transactions_url, alert: "No file selected."
    end
  end


  private

  def transaction_params
    params.require(:transaction).permit(:file, :status, :timestamp, :quantity, :amount, :batch_id)
  end
end
