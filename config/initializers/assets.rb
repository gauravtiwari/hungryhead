# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'
Rails.application.config.assets.precompile += %w( core/css/windows.chrome.fix.css )
Rails.application.config.assets.precompile += %w( core/css/ie9.css )
Rails.application.config.assets.precompile += %w( core/css/hungryhead.css )
Rails.application.config.assets.precompile += %w(*.svg *.eot *.woff *.ttf *.gif *.png *.ico)
Rails.application.config.assets.precompile += %w( application_1.css )
Rails.application.config.assets.precompile += %w( application_2.css )
Rails.application.config.assets.precompile += %w( application_3.css )
Rails.application.config.assets.precompile += %w( application_4.css )
# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
