module Scorable

  extend ActiveSupport::Concern

  class_methods do
    # load top 20 users
    def popular_20
      self.where(id: self.popular.revrange(0, 20)).order_as_specified(id: self.popular.revrange(0, 20))
    end

    # load top 20 users
    def trending_20
      self.where(id: self.trending.revrange(0, 20)).order_as_specified(id: self.popular.revrange(0, 20))
    end
  end


end