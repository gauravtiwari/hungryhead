# config/initializers/compression.rb

Rails.application.configure do
  # Use environment names or environment variables:
  # break unless Rails.env.production?
  break unless ENV['ENABLE_COMPRESSION'] == '1'

  config.middleware.use(Rack::Tracker) do
    handler :google_analytics, { tracker: ENV['GOOGLE_ANALYTICS_TRACKER'] }
    handler :go_squared, { tracker: ENV['GO_SQUARED_TRACKER'] }
  end

  MetaEvents::Tracker.default_event_receivers << Mixpanel::Tracker.new(ENV['MIXPANEL_API_KEY'])
end