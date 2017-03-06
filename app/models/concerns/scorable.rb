module Scorable
  extend ActiveSupport::Concern

  class_methods do
    # load top 20 users/ideas/feedbacks
    def popular_20
      key = "popular_20_#{to_s.pluralize.downcase}"
      Rails.cache.fetch(key, expires_in: 2.hours) do
        where(id: leaderboard.revrange(0, 20))
          .order_as_specified(id: leaderboard.revrange(0, 20))
          .map(&:card_json)
      end
    end

    # load trending 20 users/ideas/feedbacks
    def trending_20
      key = "trending_20_#{to_s.pluralize.downcase}"
      Rails.cache.fetch(key, expires_in: 2.hours) do
        where(id: trending.revrange(0, 20))
          .order_as_specified(id: trending
        .revrange(0, 20)).map(&:card_json)
      end
    end

    # load latest 20 users/ideas/feedbacks
    def latest_20
      key = "latest_20_#{to_s.pluralize.downcase}"
      Rails.cache.fetch(key, expires_in: 2.hours) do
        where(id: latest.revrange(0, 20))
          .order_as_specified(id:
        latest.revrange(0, 20)).map(&:card_json)
      end
    end
  end
end
