module Scorable

  extend ActiveSupport::Concern

  included do
    sorted_set :trending,  maxlength: 100, global: true
    sorted_set :popular,  maxlength: 100, global: true
    list :latest, maxlength: 20, marshal: true, global: true
  end

  # load top 20 users
  def self.popular_20
    self.class.popular.revrange(0, 20).map{|id| self.class.find(id)}
  end

  # load top 20 users
  def self.trending_20
    self.class.trending.revrange(0, 20).map{|id| self.class.find(id)}
  end

end