module Scorable

  extend ActiveSupport::Concern

  included do
    after_update :update_leaderboard
  end

  class_methods do
    # load top 20 users
    def popular_20
      self.where(id: self.leaderboard.revrange(0, 20)).order_as_specified(id: self.leaderboard.revrange(0, 20))
    end

    # load top 20 users
    def trending_20
      self.where(id: self.trending.revrange(0, 20)).order_as_specified(id: self.popular.revrange(0, 20))
    end
  end

  def update_leaderboard
    self.class.leaderboard[id] = score
  end

  def add_points!(point)
    self.score = point
    self.save!
  end

end