class BikeQuestion < ApplicationRecord
  belongs_to :bike
  belongs_to :user

  validates :content, presence: true
end
