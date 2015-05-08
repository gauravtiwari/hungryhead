module Follower
  extend ActiveSupport::Concern

  included do
    has_many :followings, as: :follower, class_name: 'Follow', :dependent => :destroy
  end

  # users that self follows
  def get_followers
    user_ids = followers_ids.members
    User.where(:id => user_ids)
  end

  # users that follow self
  def get_followings
    user_ids = followings_ids.members
    User.where(:id => user_ids)
  end

  # users who follow and are being followed by self
  def friends
    user_ids = followers_ids(followings_ids)
    User.where(:id => user_ids)
  end

  # does the user follow self
  def followed_by?(user)
    followers_ids.member?(user)
  end

  # does self follow user
  def following?(user)
    followings_ids.member?(user)
  end

end