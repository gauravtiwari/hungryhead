module Scorable

  extend ActiveSupport::Concern

  class_methods do

    # load top 20 users/ideas/feedbacks
    def popular_20
      max_updated_at = self.find(self.latest.revrange(0, 20)).published.maximum(:updated_at).try(:utc).try(:to_s, :number)
      Rails.cache.fetch("#{self.to_s}/#{max_updated_at}", expires_in: 2.hours) do
        self.find(self.leaderboard.revrange(0, 20)).map{|object| object.card_json }
      end
    end

    # load trending 20 users/ideas/feedbacks
    def trending_20
      max_updated_at = self.find(self.latest.revrange(0, 20)).published.maximum(:updated_at).try(:utc).try(:to_s, :number)
      Rails.cache.fetch("#{self.to_s}/#{max_updated_at}", expires_in: 2.hours) do
        self.find(self.trending.revrange(0, 20)).map{|object| object.card_json }
      end
    end

    # load latest 20 users/ideas/feedbacks
    def latest_listing
      max_updated_at = self.find(self.latest.revrange(0, 20)).published.maximum(:updated_at).try(:utc).try(:to_s, :number)
      Rails.cache.fetch("#{self.to_s}/#{max_updated_at}", expires_in: 2.hours) do
        self.find(self.latest.revrange(0, 20)).map{|object| object.card_json }
      end
    end

  end

end