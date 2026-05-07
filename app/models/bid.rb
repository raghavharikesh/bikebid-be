class Bid < ApplicationRecord
  belongs_to :user
  belongs_to :bike

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validate  :amount_higher_than_current
  validate  :auction_still_live
  validate  :wallet_has_enough_balance

  after_create :lock_wallet_amount
  after_create :extend_auction_if_snipe
  after_create :broadcast_bid

  ANTI_SNIPE_WINDOW   = 5.minutes
  AUCTION_EXTENSION   = 30.minutes
  WALLET_LOCK_PERCENT = 0.10

  def locked_amount = (amount * WALLET_LOCK_PERCENT).round(2)

  private

  def amount_higher_than_current
    min = bike.current_price + (bike.min_increment || 100)
    errors.add(:amount, "must be at least #{min}") if amount < min
  end

  def auction_still_live
    errors.add(:base, "Auction ended") if bike.auction_ended?
  end

  def wallet_has_enough_balance
    available = user.wallet.balance - user.wallet.locked_amount
    errors.add(:base, "Insufficient wallet balance to lock 10%") if available < locked_amount
  end

  def lock_wallet_amount
    WalletService.new(user.wallet).lock!(locked_amount, reference: "BID-#{id}")
    # release previous bidder's lock
    prev = bike.bids.where.not(id: id).order(amount: :desc).first
    if prev
      WalletService.new(prev.user.wallet).unlock!(prev.locked_amount, reference: "BID-#{prev.id}-OUTBID")
    end
  end

  def extend_auction_if_snipe
    if bike.auction_ends_at - Time.current < ANTI_SNIPE_WINDOW
      bike.update!(auction_ends_at: bike.auction_ends_at + AUCTION_EXTENSION)
    end
  end

  def broadcast_bid
    ActionCable.server.broadcast(
      "bike:#{bike.id}:bids",
      { id: id, amount: amount, user: user.name, ends_at: bike.reload.auction_ends_at }
    )
  end
end
