class UpdateShareCacheJob < ActiveJob::Base

  #JOB to rebuild cache for shareables
  def perform(shareable_id, shareable_type)
    @shareable = shareable_type.safe_constantize.find(shareable_id)
    @shareable.shares_counter.reset
    @shareable.sharers_ids.clear
    @shareable.shares_counter.incr(@shareable.shares.size)
    @shareable.shares.find_each do |share|
      share.shareable.sharers_ids.add(share.user.id, share.created_at.to_i)
    end
  end

end