Devise::Async.enabled = true
Devise::Async.queue = :default
Devise::Async.backend = :sidekiq