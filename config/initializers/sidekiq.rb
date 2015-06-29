location = ENV['$REDIS_ADDRESS'] || "localhost"

Sidekiq.configure_server do |config|
  config.redis = { url: "redis://#{location}:6379/5", namespace: "backgroundjobs" }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{location}:6379/5", namespace: "backgroundjobs" }
end