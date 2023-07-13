class AddTimeToTransactions < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :time, :string
  end
end
