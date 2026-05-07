class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true
  validates :line1, :city, :state, :pincode, presence: true
end

class Notification < ApplicationRecord
  belongs_to :user
  enum :kind, { bid_placed: 0, outbid: 1, won: 2, payment_due: 3, dispute: 4, admin: 5 }
  scope :unread, -> { where(read_at: nil) }
end

class Dispute < ApplicationRecord
  belongs_to :user
  belongs_to :order
  enum :status, { open: 0, investigating: 1, resolved: 2, rejected: 3 }
end

class Payment < ApplicationRecord
  belongs_to :order
  enum :status, { pending: 0, success: 1, failed: 2, refunded: 3 }
end

class JwtDenylist < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Denylist
  self.table_name = "jwt_denylists"
end

class RtoVerification < ApplicationRecord
  belongs_to :bike
  enum :status, { pending: 0, verified: 1, mismatch: 2 }
end

class ServiceHistory < ApplicationRecord
  belongs_to :bike
end
