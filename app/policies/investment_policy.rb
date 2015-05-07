class InvestmentPolicy < ApplicationPolicy

  def update?
  	current_user == record.user
  end

 def vote?
  	true
  end

  def show?   ; false; end
  def create?
   current_user != record.idea.student && record.idea.published? && !record.idea.invested?(current_user)
  end
  def destroy?; current_user == record.user; end
end

