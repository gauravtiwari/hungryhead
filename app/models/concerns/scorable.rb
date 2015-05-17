module Scorable

  extend ActiveSupport::Concern

  class_methods do
    # load top 20 users/ideas/feedbacks
    def popular_20
      self.fetch_multi(self.leaderboard.revrange(0, 20))
    end

    # load top 20 users/ideas/feedbacks
    def trending_20
      self.fetch_multi(self.trending.revrange(0, 20))
    end

    def latest_listing
      self.fetch_multi(self.latest.values)
    end

  end

end