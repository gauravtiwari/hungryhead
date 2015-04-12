location = ENV["REDISCLOUD_URL"] || 'redis://127.0.0.1:6379/0'
uri = URI.parse(location)
$redis = ConnectionPool.new(size: 5, timeout: 5) { Redis.new(:host => uri.host, :port => uri.port, :password => uri.password) }
