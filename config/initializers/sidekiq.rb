Sidekiq.configure_server do |config|
  config.redis = ReadCache.redis
end

Sidekiq.configure_client do |config|
  config.redis = ReadCache.redis
end