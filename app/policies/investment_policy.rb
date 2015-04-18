class InvestmentPolicy < ApplicationPolicy

  def update?
  	current_user == record.user
  end

 def like?
  	true
  end

  def show?   ; false; end
  def create? ; current_user != record.idea.student && record.idea.published? ; end
  def destroy?; current_user == record.user; end
end

