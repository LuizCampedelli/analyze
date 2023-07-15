# app/models/sale.rb
require 'csv'

class Sale < ApplicationRecord
  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      sale = Sale.create! row.to_hash
      sale.check_for_anomaly
    end
  end

  def check_for_anomaly
    if self.today > (self.avg_last_month * 2)
      puts "Anomaly detected at #{self.time}"
    end
  end

  def self.anomalies_over_time
    Sale.where("today > (avg_last_month * 2)")
  end
end
