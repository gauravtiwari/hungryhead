Devise::Async.setup do |config|
  Devise::Async.enabled = true
  Devise::Async.backend = :sidekiq
end