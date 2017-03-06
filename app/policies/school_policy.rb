class SchoolPolicy < ApplicationPolicy
  def follow?
    true
  end

  def update?
    record.user == current_user
  end

  def unfollow?
    current_user == record.follower
  end
end
