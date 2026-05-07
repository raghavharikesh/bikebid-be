class Dispute < ApplicationRecord
  belongs_to :user
  belongs_to :order
  enum :status, { open: 0, investigating: 1, resolved: 2, rejected: 3 }
end
