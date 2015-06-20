module Follower
  extend ActiveSupport::Concern

  included do
    has_many :followings, as: :follower, class_name: 'Follow', :dependent => :destroy
  end

  def people_you_may_know
    followings_sets = []
    User.published.find(followings_ids.members).map{|u| followings_sets << u.followings_ids }
    followings_sets.map{|f| f.difference(followings_ids) }.flatten - ["#{id}"]
  end

  # users that follow self
  def get_followings
    cache_key = "#{self.class.to_s}/followings-#{followings_ids.members.count}"
    Rails.cache.fetch(cache_key, expires_in: 2.hours) do
      User.find(followings_ids.members)
    end
  end

  # users who follow and are being followed by self
  def friends
    cache_key = "#{self.class.to_s}/friends-#{followers_ids.intersection(followings_ids).count}"
    Rails.cache.fetch(cache_key, expires_in: 2.hours) do
      User.where(:id => followers_ids.intersection(followings_ids))
    end
  end

  def is_friend?(user)
    user.followings_ids.member?(id)
  end

  def friends_count
    followers_ids.intersection(followings_ids).count
  end

  # does the user follow self
  def followed_by?(user)
    followers_ids.member?(user.id)
  end

  # does self follow user
  def following?(user)
    followings_ids.member?(user.id)
  end

end