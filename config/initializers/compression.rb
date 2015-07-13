# config/initializers/compression.rb

Rails.application.configure do
  # Use environment names or environment variables:
  # break unless Rails.env.production?
  break unless ENV['ENABLE_COMPRESSION'] == '1'
  uglifier = Uglifier.new output: { comments: :copyright }
  config.middleware.use Rack::Deflater
end