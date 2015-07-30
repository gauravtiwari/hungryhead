# Rack::MiniProfiler.config.disable_caching = false

# if Rails.env.production?
#   # set RedisStore
#   uri = URI.parse(ENV["REDIS_URL"])
#   Rack::MiniProfiler.config.storage_options = { :host => uri.host, :port => uri.port, :password => uri.password }
#   Rack::MiniProfiler.config.storage = Rack::MiniProfiler::RedisStore
# else
#   # set MemoryStore
#   Rack::MiniProfiler.config.storage = Rack::MiniProfiler::MemoryStore
# end
