module Scorable

  extend ActiveSupport::Concern

  # load top 20 users
  def self.popular_20
    self.class.popular.revrange(0, 20).map{|id| self.class.find(id)}
  end

  # load top 20 users
  def self.trending_20
    self.class.trending.revrange(0, 20).map{|id| self.class.find(id)}
  end

end