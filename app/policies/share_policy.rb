class SharePolicy < ApplicationPolicy
  def update?
  	current_user == record.user
  end

  def like?
  	current_user != record.user
  end

  def destroy?; current_user == record.user; end
end

