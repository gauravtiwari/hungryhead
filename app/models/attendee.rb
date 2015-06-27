class Attendee < ActiveRecord::Base

  belongs_to :event
  belongs_to :attendee, class_name: 'User', foreign_key: 'attendee_id'

  after_commit :increment_event_counter, on: :create
  after_commit :decrement_event_counter, on: :destroy

  private

  def increment_event_counter
    event.attendees_id << attendee_id
    event.attendees_counter.increment
  end

  def decrement_event_counter
    event.attendees_id.delete(attendee_id)
    event.attendees_counter.decrement unless event.attendees_counter.value == 0
  end

end
