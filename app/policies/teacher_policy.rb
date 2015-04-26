class TeacherPolicy < ApplicationPolicy
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

  def publish?
  	current_user == record
  end
  def show?   ;  end
  def create? ; current_user == record; end
  def destroy?; current_user == record; end
end

