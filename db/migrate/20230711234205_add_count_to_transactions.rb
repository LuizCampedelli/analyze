class AddCountToTransactions < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :count, :integer
  end
end
