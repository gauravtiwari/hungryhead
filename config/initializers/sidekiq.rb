Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://localhost:6379/5', namespace: "backgroundjobs" }
  config.server_middleware do |chain|
    chain.add Sidekiq::Status::ServerMiddleware, expiration: 30.minutes # default
  end
  config.client_middleware do |chain|
    chain.add Sidekiq::Status::ClientMiddleware
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://localhost:6379/5', namespace: "backgroundjobs" }
  config.client_middleware do |chain|
    chain.add Sidekiq::Status::ClientMiddleware
  end
end