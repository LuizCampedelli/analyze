class AddBatchIdToTransactions < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :batch_id, :integer
  end
end
