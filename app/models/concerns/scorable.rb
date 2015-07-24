module Scorable

  extend ActiveSupport::Concern

  class_methods do

    # load top 20 users/ideas/feedbacks
    def popular_20
      self.where(id: self.leaderboard.revrange(0, 20)).order_as_specified(id: self.leaderboard.revrange(0, 20)).map{|object| object.card_json }
    end

    # load trending 20 users/ideas/feedbacks
    def trending_20
      self.where(id: self.trending.revrange(0, 20)).order_as_specified(id: self.trending.revrange(0, 20)).map{|object| object.card_json }
    end

    # load latest 20 users/ideas/feedbacks
    def latest_20
      self.where(id: self.latest.revrange(0, 20)).order_as_specified(id: self.latest.revrange(0, 20)).map{|object| object.card_json }
    end

  end
end