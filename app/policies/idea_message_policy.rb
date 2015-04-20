class IdeaMessagePolicy < ApplicationPolicy

  def update?
  	current_user == record.student
  end

  def show?
  	current_user == record.student
  end

  def create?
   record.idea.founder?(current_user) || record.idea.team.include?(current_user.id.to_s)
  end

  def destroy?
   current_user == record.student
  end
end

