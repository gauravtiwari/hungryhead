class EventAttendeePolicy < ApplicationPolicy

  def leave?
    record.attendee == current_user
  end

end