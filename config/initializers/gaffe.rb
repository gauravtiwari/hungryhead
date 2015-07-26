# config/initializers/gaffe.rb
Gaffe.configure do |config|
  config.errors_controller = 'ErrorsController'
end

Gaffe.enable!