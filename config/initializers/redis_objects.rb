location = ENV['$REDIS_ADDRESS'] || "localhost"
Redis::Objects.redis = Redis.new( url: "redis://#{location}:6379/1", namespace: "redis_objects")