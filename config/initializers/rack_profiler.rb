if Rails.env == 'development'
  require 'rack-mini-profiler'
  Rack::MiniProfiler.config.disable_caching = false # defaults to true
  uri = URI.parse(ENV["REDIS_URL"])
  Rack::MiniProfiler.config.storage_options = { :host => uri.host, :port => uri.port, :password => uri.password }
  Rack::MiniProfiler.config.storage = Rack::MiniProfiler::RedisStore
  Rack::MiniProfiler.config.skip_paths = []
  # initialization is skipped so trigger it
  Rack::MiniProfilerRails.initialize!(Rails.application)
  # Do not let rack-mini-profiler disable caching

end