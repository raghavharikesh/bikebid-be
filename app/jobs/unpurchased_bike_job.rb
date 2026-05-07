class UnpurchasedBikeJob < ApplicationJob
  queue_as :default

  def perform
    Order.pending_payment.where("payment_deadline < ?", Time.current).find_each do |order|
      ActiveRecord::Base.transaction do
        bid = order.bike.highest_bid
        WalletService.new(bid.user.wallet).penalty!(
          bid.locked_amount,
          reference: "PEN-ORDER-#{order.id}"
        )
        order.update!(status: :forfeited)
        order.bike.update!(status: :expired)
        Notification.create!(user: bid.user, kind: :payment_due,
                             message: "Order ##{order.id} forfeited; deposit lost.")
      end
    end
  end
end
