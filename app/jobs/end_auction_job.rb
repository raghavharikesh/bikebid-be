class EndAuctionJob < ApplicationJob
  queue_as :default
  def perform
    Bike.where(status: :live).where("auction_ends_at <= ?", Time.current).find_each do |bike|
      AuctionService.end_auction!(bike)
    end
  end
end
