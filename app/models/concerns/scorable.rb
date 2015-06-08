module Scorable

  extend ActiveSupport::Concern

  class_methods do

    include Rails.application.routes.url_helpers

    # load top 20 users/ideas/feedbacks
    def popular_20
      max_updated_at = self.maximum(:updated_at).try(:utc).try(:to_s, :number)
      cache_key = "#{self}/popular-#{max_updated_at}"

      list = self.leaderboard.empty?
      if list
        self.published.find_each{ |record| self.leaderboard.add(record.id, record.points) }
      end

      Rails.cache.fetch(cache_key, expires_in: 2.hours) do
        self.published.where(id: self.leaderboard.revrange(0, 20))
        .order_as_specified(id: self.leaderboard.revrange(0, 20))
        .map{|object| send("#{self.to_s.downcase}_json", object)}
      end
    end

    # load top 20 users/ideas/feedbacks
    def trending_20
      max_updated_at = self.maximum(:updated_at).try(:utc).try(:to_s, :number)
      cache_key = "#{self}/trending-#{max_updated_at}"

      list = self.trending.empty?
      if list
        self.published.find_each{ |record| self.trending.add(record.id, 1) }
      end

      Rails.cache.fetch(cache_key, expires_in: 2.hours) do
        self.published.where(id: self.trending.revrange(0, 20))
        .order_as_specified(id: self.trending.revrange(0, 20))
        .map{|object| send("#{self.to_s.downcase}_json", object)}
      end

    end

    # load top 20 users/ideas/feedbacks
    def latest_listing
      max_updated_at = self.maximum(:updated_at).try(:utc).try(:to_s, :number)
      cache_key = "#{self}/latest-#{max_updated_at}"

      list = self.latest.empty?

      if list
        self.published.find_each{ |record| self.latest << record.id }
      end

      Rails.cache.fetch(cache_key, expires_in: 2.hours) do
        self.published.where(id: self.latest.values.reverse)
        .order_as_specified(id: self.latest.values.reverse)
        .map{|object| send("#{self.to_s.downcase}_json", object)}
      end
    end

    #User JSON
    def user_json(user)
      {
        id: user.uid,
        name: user.name,
        name_badge: user.user_name_badge,
        avatar: user.avatar.url(:avatar),
        url: profile_path(user),
        description: user.mini_bio
      }
    end

    #Idea JSON
    def idea_json(idea)
      {
        id: idea.uuid,
        name: idea.name,
        name_badge: idea.name_badge,
        url: idea_path(idea),
        description: idea.elevator_pitch
      }
    end

  end

end