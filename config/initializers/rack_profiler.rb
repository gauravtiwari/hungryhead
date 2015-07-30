
  require 'rack-mini-profiler'
  Rack::MiniProfiler.config.storage = Rack::MiniProfiler::MemoryStore
  #initialization is skipped so trigger it
  Rack::MiniProfilerRails.initialize!(Rails.application)

