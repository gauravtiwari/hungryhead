class FeedbackPolicy < ApplicationPolicy

  def update?
  	current_user == record.user
  end

  def vote?
  	true
  end

  def show?   ; false; end

  def create?
    current_user != record.idea.user &&
    record.idea.published? &&
    !record.idea.feedbacked?(current_user)
  end

  def destroy?; current_user == record.user; end
end

