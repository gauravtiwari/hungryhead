Sidekiq.configure_server do |config|
  config.redis = { url: ENV["REDIS_URL"], namespace: "sidekiq_#{Rails.env.downcase}" }
  ActiveRecord::Base.establish_connection
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV["REDIS_URL"], namespace: "sidekiq_#{Rails.env.downcase}" }
  ActiveRecord::Base.establish_connection
end
