class Bike < ApplicationRecord
  belongs_to :seller, class_name: "User"
  belongs_to :bike_bundle, optional: true
  has_many   :bike_images, dependent: :destroy
  has_many   :bids, dependent: :destroy
  has_one    :inspection, dependent: :destroy
  has_one    :order, dependent: :nullify
  has_one    :rto_verification, dependent: :destroy
  has_many   :service_histories, dependent: :destroy
  has_many_attached :photos

  enum :bike_type, {
    scooter: 0, commuter: 1, sports: 2, cruiser: 3,
    electric: 4, dirt_bike: 5, adventure: 6, cafe_racer: 7
  }

  enum :fuel_type, { petrol: 0, electric: 1, hybrid: 2 }
  enum :transmission, { manual: 0, automatic: 1, semi_auto: 2 }

  enum :status, {
    draft: 0, pending_approval: 1, approved: 2,
    live: 3, sold: 4, rejected: 5, expired: 6
  }

  validates :make, :model, :year, :starting_price, :engine_cc, presence: true
  validates :year, numericality: { greater_than: 1990, less_than_or_equal_to: -> (_) { Date.current.year + 1 } }
  validates :engine_cc, numericality: { greater_than_or_equal_to: 0 }
  validates :mileage_kmpl, numericality: { greater_than: 0 }, allow_nil: true

  scope :live_auctions, -> { where(status: :live).where("auction_ends_at > ?", Time.current) }

  def highest_bid       = bids.order(amount: :desc).first
  def current_price     = highest_bid&.amount || starting_price
  def auction_ended?    = auction_ends_at.present? && auction_ends_at <= Time.current
  def electric?         = fuel_type == "electric"
end
