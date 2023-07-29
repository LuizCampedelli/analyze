class TransactionImportJob < ApplicationJob
  queue_as :default

  def perform(file_path)
    Transaction.import(file_path)
  end
end
