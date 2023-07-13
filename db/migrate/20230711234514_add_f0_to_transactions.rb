class AddF0ToTransactions < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :f0_, :string
  end
end
