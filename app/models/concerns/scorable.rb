module Scorable

  extend ActiveSupport::Concern

  class_methods do
    # load top 20 users/ideas/feedbacks
    def popular_20
      self.where(id: self.leaderboard.revrange(0, 20)).order_as_specified(id: self.leaderboard.revrange(0, 20))
    end

    # load top 20 users/ideas/feedbacks
    def trending_20
      self.where(id: self.trending.revrange(0, 20)).order_as_specified(id: self.leaderboard.revrange(0, 20))
    end

    def latest_listing
      self.where(id: self.latest.values.reverse).order_as_specified(id: self.latest.values.reverse)
    end

  end

end