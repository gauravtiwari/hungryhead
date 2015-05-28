location = "redis://#{ENV['$REDIS_ADDRESS']}:6379/0/soulmate" || 'redis://127.0.0.1:6379/0/soulmate'
uri = URI.parse(location)
Soulmate.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)