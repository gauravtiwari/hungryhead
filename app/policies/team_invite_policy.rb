class TeamInvitePolicy < ApplicationPolicy

  def update?
  	current_user == record.inviter || record.invited
  end

  def create?
    current_user == record.idea.user
  end

  def destroy?
  	current_user == record.inviter
  end

end

