class NotificationSerializer
  include JSONAPI::Serializer

  attributes :id, :transaction_type, :message, :read_at, :created_at

  attribute :user_id do |n|
    n.user_id
  end

  attribute :title do |n|
    n.transaction_type.humanize
  end

  attribute :isRead do |n|
    n.read_at.present?
  end

  attribute :timestamp do |n|
    n.created_at
  end
end
