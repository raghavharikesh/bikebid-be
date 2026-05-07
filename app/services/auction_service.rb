class AuctionService
  def self.end_auction!(bike)
    return unless bike.auction_ended?
    winner_bid = bike.highest_bid
    return bike.update!(status: :expired) unless winner_bid

    ActiveRecord::Base.transaction do
      order = Order.create!(
        buyer: winner_bid.user,
        bike:  bike,
        total_amount: winner_bid.amount,
        status: :pending_payment
      )
      bike.update!(status: :sold)
      Notification.create!(user: winner_bid.user, transaction_type: :won,
                           message: "You won #{bike.make} #{bike.model}! Pay within 3 days.")
      order
    end
  end
end
