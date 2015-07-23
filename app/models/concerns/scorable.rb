module Scorable

  extend ActiveSupport::Concern

  class_methods do

    # load top 20 users/ideas/feedbacks
    def popular_20
      self.find(self.leaderboard.revrange(0, 20))
    end

    # load trending 20 users/ideas/feedbacks
    def trending_20
      self.find(self.trending.revrange(0, 20))
    end

    # load latest 20 users/ideas/feedbacks
    def latest_listing
      self.find(self.latest.revrange(0, 20))
    end

  end

end