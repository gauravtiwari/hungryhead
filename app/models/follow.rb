class Follow < ActiveRecord::Base
  acts_as_follow

  after_create :add_recent_followers
  after_destroy :update_recent_followers
end
