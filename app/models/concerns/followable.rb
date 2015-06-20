module Followable
  extend ActiveSupport::Concern

  included do
    has_many :followers, as: :followable, class_name: 'Follow', dependent: :destroy
  end

  #users that self follows
  def get_followers
    cache_key = "#{self.class.to_s}/followers-#{followers_ids.members.count}"
    Rails.cache.fetch(cache_key, expires_in: 2.hours) do
      User.find(followers_ids.members)
    end
  end

  # does the user follow self
  def followed_by?(user)
    followers_ids.member?(user.id)
  end

end