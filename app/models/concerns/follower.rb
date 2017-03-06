module Follower
  extend ActiveSupport::Concern

  included do
    has_many :followings, class_name: 'Follow', foreign_key: 'follower_id', dependent: :destroy
  end

  def people_you_may_know
    followings_sets = []
    User.published.find(followings_ids.members).map { |u| followings_sets << u.followings_ids }
    followings_sets.map { |f| f.difference(followings_ids) }.flatten - [id.to_s]
  end

  # users that follow self
  def get_followings
    User.find(followings_ids.members)
  end

  # users who follow and are being followed by self
  def friends
    User.find(followers_ids.intersection(followings_ids))
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

  # school following
  def school_following?(school)
    school_followings_ids.member?(school.id)
  end
end
