module ReadCache
  class << self
    def redis
      @redis ||=  Redis::Namespace.new("hungryhead_#{Rails.env.downcase}", :redis => Redis.new(:url => (ENV["CACHE_REDIS_URL"])))
    end
  end
end