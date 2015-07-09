HighVoltage.page_ids.each do |page|
  add page, changefreq: 'monthly'
  config.home_page = 'index'
  config.route_drawer = HighVoltage::RouteDrawers::Root
end