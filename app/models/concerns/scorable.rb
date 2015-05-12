module Scorable

  extend ActiveSupport::Concern

  class_methods do
    # load top 20 users/ideas/feedbacks
    def popular_20
      self.where(id: self.leaderboard.revrange(0, 20)).order_as_specified(id: self.leaderboard.revrange(0, 20))
    end

    # load top 20 users/ideas/feedbacks
    def trending_20
      self.where(id: self.trending.revrange(0, 20)).order_as_specified(id: self.popular.revrange(0, 20))
    end
  end

  def increment_points!(point)
    self.score += point
    self.save!
    self.class.leaderboard[id] = score
  end

  def increment_views!
    self.views += point
    self.save!
    self.class.trending[id] = views
  end

end