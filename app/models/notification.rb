class Notification < ApplicationRecord
  belongs_to :user
  enum :notification_type, { bid_placed: 0, outbid: 1, won: 2, payment_due: 3, dispute: 4, admin: 5 }
  scope :unread, -> { where(read_at: nil) }
end
