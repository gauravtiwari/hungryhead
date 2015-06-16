class MentorPolicy < ApplicationPolicy
  def index?
  	current_user == record
  end
  def update?
  	current_user == record
  end

  def unpublish?
  	current_user == record
  end

  def vote?
    true
  end

  def follow?
    current_user != record
  end

  def unfollow?
    current_user == record
  end

  def card?
    show?
  end

  def publish?
  	current_user == record
  end
  def show?   ;  record.published? || record == current_user end
  def create? ; current_user == record; end
  def destroy?; current_user == record; end
end

