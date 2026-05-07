class UserSerializer
  include JSONAPI::Serializer

  attributes :id, :email, :name, :phone, :role, :status, :created_at

  attribute :first_name do |user|
    user.name.split(' ').first
  end

  attribute :last_name do |user|
    user.name.split(' ').drop(1).join(' ')
  end

  attribute :is_verified do |_user|
    true
  end

  attribute :two_factor_enabled do |_user|
    false
  end

  attribute :wallet_balance do |user|
    user.wallet&.balance || 0
  end
end
