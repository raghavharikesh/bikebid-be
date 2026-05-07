class RtoVerification < ApplicationRecord
  belongs_to :bike
  enum :status, { pending: 0, verified: 1, mismatch: 2 }
end
