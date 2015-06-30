module ReadCache
  class << self
    def redis
      @redis ||=  ConnectionPool.new(size: 5, timeout: 5) { Redis::Namespace.new("hungryhead", :redis => Redis.new(:url => (ENV["REDIS_URL"] || 'redis://127.0.0.1:6379'))) }
    end
  end
end