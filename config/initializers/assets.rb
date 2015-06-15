# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'
Rails.application.config.assets.precompile += %w( core/css/windows.chrome.fix.css )
Rails.application.config.assets.precompile += %w( core/css/ie9.css )
Rails.application.config.assets.precompile += %w( phone.css )
Rails.application.config.assets.precompile += %w( phone.js )
Rails.application.config.assets.precompile += %w(*.svg *.eot *.woff *.ttf *.gif *.png *.ico)
# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
