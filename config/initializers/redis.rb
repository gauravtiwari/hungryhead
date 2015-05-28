location = "redis://#{ENV['$REDIS_ADDRESS']}:6379/0/cache" || 'redis://127.0.0.1:6379/0/cache'
uri = URI.parse(location)
$redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
