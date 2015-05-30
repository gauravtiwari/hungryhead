# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'
Rails.application.config.assets.precompile += %w( pages-icon/pages-icon.eot)
Rails.application.config.assets.precompile += %w( pages-icon/pages-icon.svg)
Rails.application.config.assets.precompile += %w( pages-icon/pages-icon.ttf)
Rails.application.config.assets.precompile += %w( pages-icon/pages-icon.woff)
Rails.application.config.assets.precompile += %w( icons/noti-cross-2x.png)
Rails.application.config.assets.precompile += %w( icons/noti-cross.png)
Rails.application.config.assets.precompile += %w( icons/top-tray.png)
Rails.application.config.assets.precompile += %w( icons/top-tray_2x.png)
Rails.application.config.assets.precompile += %w( .svg .eot .woff .ttf)

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
