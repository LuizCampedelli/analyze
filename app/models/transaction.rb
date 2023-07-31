require 'csv'

class Transaction < ApplicationRecord
  after_create :check_for_anomaly

  def self.import(file_data)
    # was file_path
    batch_id = Transaction.maximum(:batch_id).to_i + 1

    CSV.parse(file_data, headers: true) do |row|
      transaction_hash = row.to_hash
      transaction_hash["timestamp"] = DateTime.strptime(transaction_hash["time"], "%Hh %M") if transaction_hash["time"].present?
      transaction_hash["status"] = transaction_hash["status"]
      transaction_hash["batch_id"] = batch_id

      transaction_count = transaction_hash["count"].to_i if transaction_hash["count"].present?
      transaction_count ||= transaction_hash["f0_"].to_i if transaction_hash["f0_"].present?
      transaction_hash["quantity"] = transaction_count

      transaction = Transaction.new(transaction_hash)
      if transaction.save
        transaction.check_for_anomaly
      else
        puts transaction.errors.full_messages
      end
    end
  end

  def check_for_anomaly
    average_quantity_last_week = Transaction.where("status = ? AND timestamp >= ?", self.status, 1.week.ago).average(:quantity)
    if average_quantity_last_week.present? && self.quantity > average_quantity_last_week * 2
      self.update(flag: true)
    end
  end
end
