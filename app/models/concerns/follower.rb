module Follower
  extend ActiveSupport::Concern

  included do
    has_many :followings, as: :follower, class_name: 'Follow', :dependent => :destroy
  end

  def follows? followable
    followings_ids.values.include?(followable.id.to_s) || idea_followings_ids.values.include?(followable.id.to_s)
  end

end