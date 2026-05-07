class Review < ApplicationRecord
  belongs_to :bike
  belongs_to :user

  validates :rating, presence: true, numericality: { in: 1..5 }
end
