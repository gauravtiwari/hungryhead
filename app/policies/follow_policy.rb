class FollowPolicy < ApplicationPolicy
  def follow?
    current_user != record.followable
  end

  def unfollow?
    current_user == record.followable
  end

  def followers?
    true
  end

  def followings?
    true
  end
end
