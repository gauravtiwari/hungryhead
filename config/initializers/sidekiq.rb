Sidekiq.configure_server do |config|
  config.redis = ConnectionPool.new(size: 5, timeout: 5) { ReadCache.redis }
end

Sidekiq.configure_client do |config|
  config.redis = ConnectionPool.new(size: 5, timeout: 5) { ReadCache.redis }
end