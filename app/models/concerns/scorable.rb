module Scorable

  extend ActiveSupport::Concern

  class_methods do

    # load top 20 users/ideas/feedbacks
    def popular_20
      total = self.latest.revrange(0, 20).inject{|sum,x| sum.to_i + x.to_i }
      Rails.cache.fetch("#{self.to_s.downcase.pluralize}:popular:#{total}", expires_in: 2.hours) do
        self.find(self.leaderboard.revrange(0, 20)).map{|object| object.card_json }
      end
    end

    # load trending 20 users/ideas/feedbacks
    def trending_20
      total = self.latest.revrange(0, 20).inject{|sum,x| sum.to_i + x.to_i }
      Rails.cache.fetch("#{self.to_s.downcase.pluralize}:trending:#{total}", expires_in: 2.hours) do
        self.find(self.trending.revrange(0, 20)).map{|object| object.card_json }
      end
    end

    # load latest 20 users/ideas/feedbacks
    def latest_20
      total = self.latest.revrange(0, 20).inject{|sum,x| sum.to_i + x.to_i }
      Rails.cache.fetch("#{self.to_s.downcase.pluralize}:latest:#{total}", expires_in: 2.hours) do
        self.find(self.latest.revrange(0, 20)).map{|object| object.card_json }
      end
    end

  end

end