class Order < ApplicationRecord
  belongs_to :buyer, class_name: "User"
  belongs_to :bike
  has_one    :payment, dependent: :destroy

  enum :status, {
    pending_payment: 0, paid: 1, shipped: 2,
    delivered: 3, cancelled: 4, forfeited: 5
  }

  PAYMENT_DEADLINE_DAYS = 3

  before_create :set_deadline

  def overdue? = pending_payment? && payment_deadline < Time.current

  private

  def set_deadline
    self.payment_deadline ||= PAYMENT_DEADLINE_DAYS.days.from_now
    self.total_amount     ||= bike.current_price
  end
end
