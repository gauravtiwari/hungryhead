class TeamInvitePolicy < ApplicationPolicy

  def update?
  	current_user == record.inviter
  end

  def create?
    current_user == record.idea.user
  end

  def show?
    current_user == record.invited
  end

  def destroy?
  	current_user == record.inviter
  end

end

