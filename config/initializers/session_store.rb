# Be sure to restart your server when you modify this file.
uri = URI.parse(ENV["SESSION_REDIS_URL"])
Rails.application.config.session_store :redis_session_store, {
  key: 'hungryhead',
  serializer: :hybrid,
  redis: {
    db: 4,
    expire_after: 120.minutes,
    key_prefix: 'hungryhead:session:',
    host: uri.host, # Redis host name, default is localhost
    port: uri.port   # Redis port, default is 6379
  }
}