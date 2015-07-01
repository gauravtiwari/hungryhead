redis_conn = proc{
  ReadCache.redis
}
Sidekiq.configure_server do |config|
  config.redis = ConnectionPool.new(size: 250, &redis_conn)
end

Sidekiq.configure_client do |config|
  config.redis = ConnectionPool.new(size: 250, &redis_conn)
end