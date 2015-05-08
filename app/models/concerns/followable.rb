module Followable
  extend ActiveSupport::Concern

  included do
    has_many :followers, as: :followable, class_name: 'Follow', dependent: :destroy
  end

  #users that self follows
  def get_followers
   user_ids = followers_ids.members
   User.where(:id => user_ids)
  end

  # does the user follow self
  def followed_by?(user)
    followers_ids.member?(user)
  end

end