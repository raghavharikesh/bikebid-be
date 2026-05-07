require_relative "boot"
require "rails/all"
require "active_record/railtie"

Bundler.require(*Rails.groups)

module Bikebid
  class Application < Rails::Application
    config.load_defaults 8.0
    config.api_only = true
    config.time_zone = "Asia/Kolkata"
    config.active_job.queue_adapter = :solid_queue
    config.cache_store = :solid_cache_store
  end
end
