class CreateSales < ActiveRecord::Migration[7.0]
  def change
    create_table :sales do |t|
      t.string :time
      t.integer :today
      t.integer :yesterday
      t.integer :same_day_last_week
      t.float :avg_last_week
      t.float :avg_last_month

      t.timestamps
    end
  end
end
