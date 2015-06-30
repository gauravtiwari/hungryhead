class UnpublishIdeaJob < ActiveJob::Base

  def perform(idea)
   ActiveRecord::Base.connection_pool.with_connection do
  	Activity.where(trackable_id: idea.id, trackable_type: "Idea").find_each do |activity|
       if activity && activity.published?
        activity.published = false
        Idea.latest.delete(idea.id)
        Idea.popular.delete(idea.id)
        Idea.trending.delete(idea.id)
        idea.school.ideas_counter.decrement
        idea.user.ideas_counter.decrement
        activity.user.latest_activitities.remrangebyscore(activity.created_at.to_i + activity.id, activity.created_at.to_i + activity.id)
        idea.school.published_ideas.delete(idea.id)
        activity.save!
        true
       end
    end
   end
  end
end
