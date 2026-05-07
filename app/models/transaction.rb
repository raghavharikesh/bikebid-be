class Transaction < ApplicationRecord
  belongs_to :wallet

  # Correct syntax for Rails 8
  enum :transaction_type, {
    credit: 0,
    debit: 1,
    lock: 2,      # renamed from lock
    unlock: 3,   # renamed from unlock
    penalty: 4
  }, prefix: :tx

  enum :status, {
    pending: 0,
    completed: 1,
    failed: 2,
    reversed: 3
  }

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :reference, presence: true, uniqueness: true

  before_validation :generate_reference, on: :create

  private

  def generate_reference
    self.reference ||= "TRN-#{SecureRandom.alphanumeric(8).upcase}"
  end
end