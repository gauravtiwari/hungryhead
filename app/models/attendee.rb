class EventAttendee < ActiveRecord::Base

  belongs_to :event, touch: true
  belongs_to :attendee, class_name: 'User', foreign_key: 'event_attendee_id'

  after_commit :update_counters, :cache_attendees_ids, on: :create
  after_commit :update_counters, :delete_cached_attendees_ids, on: :destroy

  private

  def update_counters
    event.attendees_counter.reset
    event.attendees_counter.incr(event.attendees.size)
  end

  def cache_attendees_ids
    event.attendees_ids << attendee_id unless event.attending?(attendee)
  end

  def delete_cached_attendees_ids
    event.attendees_ids.delete(attendee_id)
  end

end
