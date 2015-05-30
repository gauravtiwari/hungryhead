require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
require "coffee-rails"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module HungryheadSchoolApp
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    config.assets.paths << Rails.root.join('vendor', 'hh')
    config.assets.paths << Rails.root.join('app', 'assets', 'fonts')
    config.assets.paths << Rails.root.join('vendor', 'hh', 'core')
    config.assets.paths << Rails.root.join('vendor', 'hh', 'core', 'css')

    config.autoload_paths += Dir["#{config.root}/app/models/*"]
    config.autoload_paths += Dir["#{config.root}/app/jobs/*"]
    config.autoload_paths += Dir["#{config.root}/app/observers/*"]
    config.autoload_paths += Dir["#{config.root}/app/listeners/*"]
    config.autoload_paths += Dir["#{config.root}/app/controllers/*"]
    config.autoload_paths += Dir["#{config.root}/app/services/*"]
    config.autoload_paths += Dir["#{config.root}/app/lib/*"]

    config.app_generators.scaffold_controller = :scaffold_controller

    #Background job processing
    config.active_job.queue_adapter = :sidekiq

    #React coding style
    config.react.jsx_transform_options = {
      harmony: true,
      strip_types: true,
    }

    config.react.max_renderers = 10
    config.react.timeout = 20 #seconds
    config.react.react_js = lambda {File.read(::Rails.application.assets.resolve('react.js'))}
    config.react.component_filenames = ['components.js']


    config.active_record.schema_format = :sql

    #config.skylight.environments += ['production']
    #config.skylight.logger = Logger.new(STDOUT)
    #config.skylight.probes = %w(net_http redis)
    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
  end
end
