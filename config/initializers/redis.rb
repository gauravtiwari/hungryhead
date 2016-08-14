module ReadCache
  class << self
    def redis
      @redis ||=  Redis::Namespace.new("hungryhead_#{Rails.env.downcase}", :redis => Redis.new(:url => (ENV["REDIS_URL"])))
    end
  end
end
