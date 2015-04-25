module Followable
  extend ActiveSupport::Concern
  included do
    has_many :followings, as: :followable, :dependent => :destroy
  end

  def ClassMethods
    def follower?(user)
      followers_ids.members.include?(user.id.to_s)
    end

    def followers
      User.find(followers_ids.revrange(0,16))
    end
  end
end