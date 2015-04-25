class UnpublishIdeaJob < ActiveJob::Base

  def perform(idea)
   ActiveRecord::Base.connection_pool.with_connection do
  	Activity.where(trackable_id: idea.id, trackable_type: "Idea").find_each do |activity|
       if activity && activity.published?
        activity.published = false
        activity.save!
        true
       end
    end
   end
  end
end
