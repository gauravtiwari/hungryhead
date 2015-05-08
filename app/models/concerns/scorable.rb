module Scorable

  extend ActiveSupport::Concern

  # load top 20 users
  def self.popular_20
    User.popular.revrange(0, 20).map{|id| User.find(id)}
  end

  # load top 20 users
  def self.trending_20
    User.trending.revrange(0, 20).map{|id| User.find(id)}
  end

end