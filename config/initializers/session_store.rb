# Be sure to restart your server when you modify this file.

Rails.application.config.session_store :redis_session_store, {
  key: 'hungryhead',
  serializer: :hybrid,
  redis: {
    db: 2,
    expire_after: 120.minutes,
    key_prefix: 'hungryhead:session:',
    host: 'localhost', # Redis host name, default is localhost
    port: 6379   # Redis port, default is 6379
  }
}