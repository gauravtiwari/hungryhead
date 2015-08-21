class EventPolicy < ApplicationPolicy

  def join?
    record.user_type == "School" ? record.user.user != current_user : record.user != current_user
  end

end