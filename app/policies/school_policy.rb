class InstitutionPolicy < ApplicationPolicy

  def follow?
    true
  end

  def update?
    record.admin == current_user
  end

  def unfollow?
    current_user == record.follower
  end
end