class UnpublishIdeaJob < ActiveJob::Base

  def perform(idea)
   ActiveRecord::Base.connection_pool.with_connection do
  	Activity.where(trackable_id: idea.id, trackable_type: "Idea").find_each do |activity|
       if activity && activity.published?
        activity.published = false

        Idea.latest.delete(idea.id)
        Idea.leaderboard.delete(idea.id)
        Idea.trending.delete(idea.id)

        idea.school.ideas_counter.decrement if Idea.leaderboard.member?(idea.id)
        idea.user.ideas_counter.decrement if Idea.leaderboard.member?(idea.id)

        #Remove from user latest activities
        activity.user.latest_activities.remrangebyscore(activity.created_at.to_i + activity.id, activity.created_at.to_i + activity.id)

        #Remove activity from follower and recipient
        find_followers(activity).each do |f|
          f.ticker.remrangebyscore(activity.created_at.to_i + activity.id, activity.created_at.to_i + activity.id)
        end

        idea.school.published_ideas.delete(idea.id)
        activity.save!

        true
       end
    end
   end
  end

  #Get all followers followed by actor
  def find_followers(activity)
    followers_ids = activity.user.followers_ids.members
    User.fetch_multi(followers_ids)
  end

end
