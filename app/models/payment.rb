class Payment < ApplicationRecord
  belongs_to :order
  enum :status, { pending: 0, success: 1, failed: 2, refunded: 3 }
end
