class PublishIdeaJob < ActiveJob::Base
  include Rails.application.routes.url_helpers

  def perform(idea_id, user_id, activity_id)
    ActiveRecord::Base.connection_pool.with_connection do
      # Fetch records
      @user = User.find(user_id)
      @idea = Idea.find(idea_id)
      @activity = Activity.find(activity_id)
      @school = School.find(@idea.school_id)

      # Rebuild counters for school
      @school.ideas_counter.reset
      @school.ideas_counter.incr(@school.get_published_ideas.length)

      # Rebuild counters for user
      @user.ideas_counter.reset
      @user.ideas_counter.incr(@user.ideas.size)

      # Insert into cache list
      Idea.latest.add(@idea.id, @idea.created_at.to_i + @idea.id)
      Idea.trending.add(@idea.id, @idea.impressions.size)
      Idea.leaderboard.add(@idea.id, @idea.points)

      # Update publish date time
      @idea.published_date = Time.now
      @idea.save

      # Pusher notification for new idea
      Pusher.trigger_async('ideas-channel',
                           'new_idea',
                           { data: @idea.card_json }.to_json)

      Idea.trending.remrangebyrank(0, -20)
    end
  end
end
