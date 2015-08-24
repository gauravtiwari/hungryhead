class EventAttendee < ActiveRecord::Base

  belongs_to :event, -> {with_deleted}, touch: true
  belongs_to :attendee, -> {with_deleted}, class_name: 'User', foreign_key: 'attendee_id'

  before_destroy :update_counters, :delete_cached_attendees_ids
  after_commit :update_counters, :cache_attendees_ids, on: :create

  private

  def update_counters
    event.attendees_counter.reset
    event.attendees_counter.incr(event.event_attendees.size)
  end

  def cache_attendees_ids
    event.attendees_ids << attendee_id unless event.attending?(attendee)
  end

  def delete_cached_attendees_ids
    event.attendees_ids.delete(attendee_id)
  end
end
