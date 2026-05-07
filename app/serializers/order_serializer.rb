class OrderSerializer
  include JSONAPI::Serializer

  attributes :id, :status, :total_amount, :payment_deadline, :created_at

  attribute :buyer do |order|
    { id: order.buyer_id, name: order.buyer.name, email: order.buyer.email }
  end

  attribute :bike do |order|
    {
      id: order.bike_id,
      make: order.bike.make,
      model: order.bike.model,
      year: order.bike.year
    }
  end
end
