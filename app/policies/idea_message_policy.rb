class IdeaMessagePolicy < ApplicationPolicy
  def update?
    current_user == record.user
  end

  def show?
    current_user == record.user
  end

  def create?
    record.idea.in_team?(current_user)
  end

  def destroy?
    current_user == record.user
  end
end
