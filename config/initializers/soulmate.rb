location = ENV['$REDIS_ADDRESS'] || "localhost"
Soulmate.redis = Redis.new( url: "redis://#{location}:6379/2", namespace: "soulmate_search")