location = ENV['$REDIS_ADDRESS'] || "localhost"
Redis::Objects.redis = ConnectionPool.new(size: 5, timeout: 5) { Redis.new( url: "redis://#{location}:6379/1", namespace: "redis_objects") }