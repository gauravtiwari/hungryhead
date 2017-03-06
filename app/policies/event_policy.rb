class EventPolicy < ApplicationPolicy
  def join?
    record.user_type == 'School' ? record.user.user != current_user : record.user != current_user
  end

  def update?
    record.user_type == 'School' ? record.user.user == current_user : record.user == current_user
  end

  def publish?
    update?
  end

  def unpublish?
    update?
  end
end
