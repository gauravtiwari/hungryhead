module Scorable

  extend ActiveSupport::Concern

  class_methods do

    include Rails.application.routes.url_helpers

    # load top 20 users/ideas/feedbacks
    def popular_20
      Rails.cache.fetch_multi(cache_key, expires_in: 24.hours) do
        self.where(id: self.leaderboard.revrange(0, 20)).order_as_specified(id: self.leaderboard.revrange(0, 20))
      end
    end

    # load top 20 users/ideas/feedbacks
    def trending_20
      Rails.cache.fetch_multi(cache_key, expires_in: 24.hours) do
        self.where(id: self.trending.revrange(0, 20)).order_as_specified(id: self.trending.revrange(0, 20))
      end
    end

    def latest_listing
      Rails.cache.fetch_multi(cache_key, expires_in: 24.hours) do
        self.where(id: self.latest.values.reverse).order_as_specified(id: self.latest.values.reverse)
      end
    end

    def cache_key
      max_updated_at = self.class.maximum(:updated_at).try(:utc).try(:to_s, :number)
      "#{self.class.pluralize}/all-#{max_updated_at}"
    end

  end

end