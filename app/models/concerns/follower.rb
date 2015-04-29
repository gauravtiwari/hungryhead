module Follower
  extend ActiveSupport::Concern

  included do
    has_many :followings, as: :follower, class_name: 'Follow', :dependent => :destroy
  end

  def followed?(followable)
    followings_ids.members.include? followable.id.to_s
  end

  def follows? followable
    followings_ids.members.include? followable.id.to_s
  end

end