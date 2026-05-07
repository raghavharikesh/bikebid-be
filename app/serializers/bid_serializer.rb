class BidSerializer
  include JSONAPI::Serializer

  attributes :id, :amount, :created_at

  attribute :bike_id do |bid|
    bid.bike_id
  end

  attribute :user_id do |bid|
    bid.user_id
  end

  attribute :user do |bid|
    { id: bid.user_id, name: bid.user.name }
  end

  attribute :bid_status do |bid|
    bid.created_at
  end
end
