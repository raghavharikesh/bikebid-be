class DisputeSerializer
  include JSONAPI::Serializer

  attributes :id, :status, :reason, :resolution, :created_at

  attribute :bike_id do |dispute|
    dispute.order&.bike_id
  end

  attribute :buyer_id do |dispute|
    dispute.user_id
  end

  attribute :order_id do |dispute|
    dispute.order_id
  end
end
