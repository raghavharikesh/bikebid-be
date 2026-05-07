source "https://rubygems.org"

ruby "3.3.0"

gem "rails", "~> 8.0.0"
gem "pg", "~> 1.5"
gem "puma", ">= 6.0"
gem "thruster", require: false

# Auth
gem "devise"
gem "devise-jwt"

# API & Serialization
gem "jsonapi-serializer"
gem "rack-cors"
gem "kaminari"

# Storage
gem "aws-sdk-s3", require: false
gem "image_processing", "~> 1.2"

# Solid suite (Rails 8 defaults — no Redis needed)
gem "solid_queue"
gem "solid_cache"
gem "solid_cable"

# Realtime
# gem "redis", ">= 5.0"
# gem "redis-client", ">= 0.22"
# gem "connection_pool", ">= 3.1.0"

# Utilities
gem "bcrypt", "~> 3.1.7"
gem "bootsnap", require: false
gem "tzinfo-data", platforms: %i[windows jruby]

# Deployment
gem "kamal", require: false

group :development, :test do
  gem "debug", platforms: %i[mri windows]
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
end

group :development do
  gem "web-console"
  gem "listen"
end
