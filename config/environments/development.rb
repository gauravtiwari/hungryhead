Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.cache_store = :readthis_store, ENV.fetch('REDIS_URL'), {
    compress: true,
    compression_threshold: 2.kilobytes
  }
  config.identity_cache_store = :dalli_store, ENV["MEMCACHE_SERVER"],
  { :namespace => "identity_cache_development", compress: true }

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  #Load react development variant
  config.react.variant = :development

  config.logger = Logger.new(STDOUT)
  config.logger.level = Logger.const_get(
    ENV['LOG_LEVEL'] ? ENV['LOG_LEVEL'].upcase : 'DEBUG'
  )

  config.active_record.raise_in_transactional_callbacks = true

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = false

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  config.action_mailer.perform_deliveries = true

  config.action_controller.asset_host = 'http://localhost:3000/'
  config.action_mailer.asset_host = 'http://localhost:3000/'

  config.action_mailer.default_url_options = { host: 'localhost:3000', port: '3000' }
  Rails.application.routes.default_url_options = { host: 'localhost:3000', port: '3000' }
  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true
  config.after_initialize do
    Bullet.enable = false
    Bullet.alert = true
    Bullet.rails_logger = true
  end
end
