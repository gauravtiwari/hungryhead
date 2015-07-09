# config/initializers/high_voltage.rb
HighVoltage.configure do |config|
  config.home_page = 'index'
  config.route_drawer = HighVoltage::RouteDrawers::Root
end