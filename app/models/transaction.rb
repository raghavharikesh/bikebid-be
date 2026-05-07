class Transaction < ApplicationRecord
  belongs_to :wallet

  enum :kind, { credit: 0, debit: 1, lock: 2, unlock: 3, penalty: 4 }
  enum :status, { pending: 0, completed: 1, failed: 2, reversed: 3 }

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :reference, presence: true, uniqueness: true

  before_validation :generate_reference, on: :create

  private

  def generate_reference
    self.reference ||= "TRN-#{SecureRandom.alphanumeric(8).upcase}"
  end
end
