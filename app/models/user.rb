class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  has_one  :wallet, dependent: :destroy
  has_many :bikes, foreign_key: :seller_id, dependent: :destroy
  has_many :bids, dependent: :destroy
  has_many :orders, foreign_key: :buyer_id, dependent: :destroy
  has_many :bike_bundles, foreign_key: :seller_id, dependent: :destroy
  has_many :addresses, as: :addressable, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :disputes, dependent: :destroy

  enum :role, { buyer: 0, seller: 1, both: 2, technician: 3, admin: 4 }
  enum :status, { active: 0, suspended: 1, banned: 2 }

  validates :name, :phone, presence: true
  validates :phone, uniqueness: true

  after_create :create_wallet_record

  # NOTE: enum :role already provides admin? and technician? predicates
  # No need to redefine them

  private

  def create_wallet_record
    Wallet.create!(user: self, balance: 0, locked_amount: 0)
  end
end
