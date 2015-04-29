module Followable
  extend ActiveSupport::Concern

  included do
    has_many :followers, as: :followable, class_name: 'Follow', dependent: :destroy
  end

  def follower?(followable)
    followers_ids.include?(followable.id.to_s)
  end

  def followers
    followers_ids
  end
end