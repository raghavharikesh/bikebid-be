# config/environments/development.rb

require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Code is reloaded on every request (good for development)
  config.enable_reloading = true

  # Do not eager load code on boot
  config.eager_load = false

  # Show full error reports
  config.consider_all_requests_local = true

  # Enable server timing
  config.server_timing = true

  # Caching (toggle with rails dev:cache)
  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true
    config.public_file_server.headers = {
      "Cache-Control" => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false
  end

  # Store uploaded files locally
  config.active_storage.service = :local

  # Mailer (no errors if not configured)
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.perform_caching = false

  # Deprecation warnings
  config.active_support.deprecation = :log

  # Raise error on pending migrations
  config.active_record.migration_error = :page_load

  # Verbose query logs
  config.active_record.verbose_query_logs = true

  # Highlight code that triggered DB queries
  config.active_record.query_log_tags_enabled = true

  # Logs
  config.log_level = :debug

  # Use default formatter
  config.log_formatter = ::Logger::Formatter.new

  # Use an evented file watcher
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
end