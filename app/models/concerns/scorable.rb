module Scorable

  extend ActiveSupport::Concern

  class_methods do

    include Rails.application.routes.url_helpers

  # load top 20 users/ideas/feedbacks
  def popular_20
    max_updated_at = self.maximum(:updated_at).try(:utc).try(:to_s, :number)
    cache_key = "#{self}/popular-#{max_updated_at}"
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
    Rails.cache.fetch(cache_key, expires_in: 2.hours) do
      self.published.where(id: self.trending.revrange(0, 20))
      .order_as_specified(id: self.trending.revrange(0, 20))
      .map{|object| send("#{self.to_s.downcase}_json", object)}
    end
  end

  def latest_listing
    max_updated_at = self.maximum(:updated_at).try(:utc).try(:to_s, :number)
    cache_key = "#{self}/latest-#{max_updated_at}"
    Rails.cache.fetch(cache_key, expires_in: 2.hours) do
      self.published.where(id: self.latest.values.reverse)
      .order_as_specified(id: self.latest.values.reverse)
      .map{|object| send("#{self.to_s.downcase}_json", object)}
    end
  end

  def user_json(user)
    {
      id: user.id,
      name: user.name,
      name_badge: user.user_name_badge,
      avatar: user.avatar.url(:avatar),
      url: profile_path(user),
      description: user.mini_bio
    }
  end

  def idea_json(idea)
    {
      id: idea.id,
      name: idea.name,
      name_badge: idea.name_badge,
      url: idea_path(idea),
      description: idea.elevator_pitch
    }
  end

end

end