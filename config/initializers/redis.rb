location = ENV['$REDIS_ADDRESS'] || "localhost"
$redis = ConnectionPool.new(size: 5, timeout: 5) { Redis.new( url: "redis://#{location}:6379/0", namespace: "redis_main") }
