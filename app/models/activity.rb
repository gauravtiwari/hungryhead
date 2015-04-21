class Activity < PublicActivity::Activity

  def cache_activities
    CacheUserActivityService.new(self).create_redis_cache
    if recipient_type == "Idea"
      CacheIdeaActivityService.new(self).create_redis_cache
    end
  end

  def delete_cached_activities
    CacheUserActivityService.new(self).delete_redis_cache
    if recipient_type == "Idea"
      CacheIdeaActivityService.new(self).delete_redis_cache
    end
  end

end
