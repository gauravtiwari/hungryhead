class EventInvite < ActiveRecord::Base

  belongs_to :invited, class_name: 'User', foreign_key: 'invited_id'
  belongs_to :inviter, polymorphic: true, touch: true
  belongs_to :event, touch: true

  after_commit :update_counters, :cache_invites_ids, on: :create
  after_commit :update_counters, :delete_cached_invites_ids, on: :destroy

  private

  def update_counters
    event.invites_counter.reset
    event.invites_counter.incr(event.invited.size)
  end

  def cache_invites_ids
    event.invites_ids << invited_id unless event.invited?(invited)
  end

  def delete_cached_invites_ids
    event.invites_ids.delete(invited_id)
  end

end
