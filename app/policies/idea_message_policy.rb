class IdeaMessagePolicy < ApplicationPolicy
  def update?
  	current_user == record.user
  end
  def show? 
  	current_user == record.user
  end
  def create?
   record.idea.team.include? current_user.id.to_s
  end
  def destroy?
   current_user == record.user
  end
end

