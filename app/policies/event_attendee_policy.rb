class EventAttendeePolicy < ApplicationPolicy

  def join?
    true
  end

  def leave?
    record.attendee == current_user
  end

end