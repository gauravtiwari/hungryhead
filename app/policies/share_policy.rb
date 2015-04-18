class SharePolicy < ApplicationPolicy
  def update?
  	current_user == record.user
  end

  def like?
  	true
  end

  def destroy?; current_user == record.user; end
end

