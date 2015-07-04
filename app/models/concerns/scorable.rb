module Scorable

  extend ActiveSupport::Concern

  class_methods do

    include Rails.application.routes.url_helpers

    # load top 20 users/ideas/feedbacks
    def popular_20
      self.fetch_multi(self.leaderboard.revrange(0, 20))
    end

    # load top 20 users/ideas/feedbacks
    def trending_20
      self.fetch_multi(self.trending.revrange(0, 20))
    end

    # load top 20 users/ideas/feedbacks
    def latest_listing
      self.fetch_multi(self.latest.revrange(0, 20))
    end

  end

end