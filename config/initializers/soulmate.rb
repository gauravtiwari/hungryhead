location = ENV['$REDIS_ADDRESS'] || "localhost"
Soulmate.redis = ConnectionPool.new(size: 5, timeout: 5) { Redis.new( url: "redis://#{location}:6379/2", namespace: "soulmate") }