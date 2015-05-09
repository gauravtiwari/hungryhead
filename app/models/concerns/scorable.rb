module Scorable

  extend ActiveSupport::Concern

  class_methods do
    # load top 20 users
    def popular_20
      self.popular.revrange(0, 100)
    end

    # load top 20 users
    def trending_20
      self.trending.revrange(0, 100)
    end
  end


end