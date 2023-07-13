class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.string :status
      t.datetime :timestamp
      t.integer :quantity
      t.boolean :flag

      t.timestamps
    end
  end
end
