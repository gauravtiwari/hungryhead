Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = true

  # Do not eager load code on boot.
  config.eager_load = true

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = true

  config.cache_store = :readthis_store, {
    expires_in: 2.weeks.to_i,
    namespace: "cache_#{Rails.env.downcase}",
    redis: { url: ENV.fetch('CACHE_REDIS_URL'), driver: :hiredis }
  }

  config.sass.inline_source_maps = true
  config.sass.line_comments = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  #Load react development variant
  config.react.variant = :development

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
