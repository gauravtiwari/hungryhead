Redis::Objects.redis = Redis::Namespace.new("graph_data_#{Rails.env.downcase}", :redis => Redis.new(:url => (ENV["REDIS_URL"])))
