class TransactionSerializer
  include JSONAPI::Serializer

  attributes :id, :transaction_type, :status, :amount, :reference, :note, :created_at

  attribute :type do |t|
    t.transaction_type
  end

  attribute :description do |t|
    t.note || t.reference
  end

  attribute :timestamp do |t|
    t.created_at
  end

  attribute :wallet_id do |t|
    t.wallet_id
  end

  attribute :user do |t|
    user = t.wallet.user
    { id: user.id, name: user.name, email: user.email }
  end
end
