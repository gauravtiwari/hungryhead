class InstitutionPolicy < ApplicationPolicy

  def follow?
    true
  end

  def unfollow?
    current_user == record.follower
  end
end