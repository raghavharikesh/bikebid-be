class BikeImage < ApplicationRecord
  belongs_to :bike
  has_one_attached :image
  enum :angle, { front: 0, rear: 1, left: 2, right: 3, engine: 4, odometer: 5, other: 6 }
end
