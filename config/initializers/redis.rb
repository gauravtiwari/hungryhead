location = "redis://#{ENV['$REDIS_ADDRESS']}:6379/0/"
uri = URI.parse(location)
$redis = Redis::Namespace.new("hungryhead", :redis => Redis.new(:host => uri.host, :port => uri.port, :password => uri.password))
