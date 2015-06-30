module Followable

  extend ActiveSupport::Concern

  included do
    has_many :followers, as: :followable, class_name: 'Follow', dependent: :destroy
    cache_has_many :followers, inverse_name: :followable, embed: true
  end

  #users that self follows
  def get_followers
    User.fetch_multi(followers_ids.members)
  end

  # does the user follow self
  def followed_by?(user)
    followers_ids.member?(user.id)
  end

end