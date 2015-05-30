# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'
Rails.application.config.assets.precompile += %w( react_ujs.js )
Rails.application.config.assets.precompile += %w( jquery2.js )
Rails.application.config.assets.precompile += %w( icons/noti-cross-2x.png)
Rails.application.config.assets.precompile += %w( icons/noti-cross.png)
Rails.application.config.assets.precompile += %w( icons/top-tray.png)
Rails.application.config.assets.precompile += %w( icons/top-tray_2x.png)
Rails.application.config.assets.precompile << /\.(?:svg|eot|woff|ttf)\z/
Rails.application.config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif *.css *.js)

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
