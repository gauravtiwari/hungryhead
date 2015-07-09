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

    config.assets.paths << File.join(Rails.root, "/vendor/hh")
    config.assets.paths << File.join(Rails.root, "/vendor/assets")

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

    config.react.server_renderer_pool_size  ||= 1  # ExecJS doesn't allow more than one on MRI
    config.react.server_renderer_timeout    ||= 20 # seconds
    config.react.server_renderer = React::ServerRendering::SprocketsRenderer
    config.react.server_renderer_options = {
      files: ["react.js", "components.js", "underscore.js", "jquery.js", "bootstrap-tagsinput.js", "js-routes.js", "showdown.js"], # files to load for prerendering
      replay_console: true,                 # if true, console.* will be replayed client-side
    }

    config.react.addons = true

    # config/application.rb
    config.generators do |g|
      g.assets = false
      g.helper = false
      g.view_specs      false
      g.helper_specs    false
    end

    config.active_record.schema_format = :sql

  end
end
