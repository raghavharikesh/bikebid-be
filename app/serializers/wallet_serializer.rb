class WalletSerializer
  include JSONAPI::Serializer

  attributes :id, :balance, :created_at

  attribute :user_id do |wallet|
    wallet.user_id
  end

  attribute :lockedAmount do |wallet|
    wallet.locked_amount
  end

  attribute :transactions do |wallet|
    wallet.transactions.order(created_at: :desc).limit(50).map do |t|
      {
        id: t.id,
        type: t.transaction_type,
        amount: t.amount,
        description: t.note || t.reference,
        timestamp: t.created_at,
        status: t.status,
        reference: t.reference
      }
    end
  end

  attribute :pendingDeposits do |wallet|
    wallet.transactions.where(transaction_type: :credit, status: :pending).map do |t|
      {
        id: t.id,
        amount: t.amount,
        paymentMethod: 'bank_transfer',
        timestamp: t.created_at,
        status: 'pending'
      }
    end
  end
end
