location = 'redis://' + ENV["REDIS_ADDRESS"] || 'redis://127.0.0.1:6379/0'
uri = URI.parse(location)
$redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
