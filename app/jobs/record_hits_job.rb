class RecordHitsJob < ActiveJob::Base

  def perform(punchable_id, punchable_type)
    @punchable = punchable_type.safe_constantize.find(punchable_id)
    @punchable.punch(request)
    @punchable.views_counter.increment
  end

end