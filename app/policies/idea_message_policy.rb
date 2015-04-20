class IdeaMessagePolicy < ApplicationPolicy

  def update?
  	current_user == record.student
  end

  def show?
  	current_user == record.student
  end

  def create?
   record.idea.in_team?(current_user)
  end

  def destroy?
   current_user == record.student
  end
end

