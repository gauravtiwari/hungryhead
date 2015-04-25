module Followable
  extend ActiveSupport::Concern
  included do
    has_many :follows, as: :followable, :dependent => :destroy
  end

  def follower?(followable)
    followers_ids.members.include?(followable.id.to_s)
  end

  def followers
    User.find(followers_ids.revrange(0,16))
  end
end