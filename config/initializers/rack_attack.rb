# config/initializers/rack_attack.rb

Rails.application.configure do
  # break unless Rails.env.production?
  break unless Rails.env.production?
  config.middleware.use Rack::Attack
end