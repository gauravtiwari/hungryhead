Soulmate.redis = Redis::Namespace.new("search_data_#{Rails.env.downcase}", :redis => Redis.new(:url => (ENV["REDIS_URL"])))
