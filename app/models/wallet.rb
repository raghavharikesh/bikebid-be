class Wallet < ApplicationRecord
  belongs_to :user
  has_many :transactions, dependent: :destroy

  validates :balance, :locked_amount, numericality: { greater_than_or_equal_to: 0 }

  def available = balance - locked_amount
end
