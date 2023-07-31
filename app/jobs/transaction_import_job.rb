class TransactionImportJob < ApplicationJob
  queue_as :default

  def perform(file_data)
    # was file_path
    Transaction.import(file_data)
  end
end
