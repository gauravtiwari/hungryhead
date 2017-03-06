class UnpublishIdeaJob < ActiveJob::Base
  def perform(idea_id)
    ActiveRecord::Base.connection_pool.with_connection do
      # Fetch everything fresh // What if it doesn't exist? Fix ME
      @idea = Idea.find(idea_id)
      @user = User.find(@idea.user_id)
      @school = School.find(@idea.school_id)

      Activity.where(trackable_id: @idea).find_each do |activity|
        if activity && activity.published?

          activity.published = false

          # Update ideas redis caching
          Idea.latest.delete(@idea.id)
          Idea.leaderboard.delete(@idea.id)
          Idea.trending.delete(@idea.id)

          # Rebuild counters for school
          @school.ideas_counter.reset
          @school.ideas_counter.incr(@school.get_published_ideas.length)

          # Rebuild counters for user
          @user.ideas_counter.reset
          @user.ideas_counter.incr(@user.ideas.size)

          # Remove activity from follower and recipient
          find_followers(activity).each do |f|
            # Find and remove from redis
            f.ticker.remrangebyscore(activity.created_at.to_i + activity.id,
                                     activity.created_at.to_i + activity.id)
          end

          # Save the activity in DB
          activity.save!

        end
      end
    end
  end

  # Get all followers followed by actor
  def find_followers(activity)
    followers_ids = activity.user.followers_ids.members
    User.find(followers_ids)
  end
end
