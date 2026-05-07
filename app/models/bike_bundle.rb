class BikeBundle < ApplicationRecord
  belongs_to :seller, class_name: "User"
  has_many :bikes, dependent: :nullify
  validates :title, presence: true
end
