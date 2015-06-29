location = ENV['$REDIS_ADDRESS'] || "localhost"
$redis = Redis.new( url: "redis://#{location}:6379/0", namespace: "redis_main")
