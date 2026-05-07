class BidChannel < ApplicationCable::Channel
  def subscribed
    bike = Bike.find(params[:bike_id])
    stream_from "bike:#{bike.id}:bids"
  end
end
