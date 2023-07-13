class TransactionsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "transactions_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
