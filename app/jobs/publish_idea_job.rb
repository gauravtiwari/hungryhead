class PublishIdeaJob < ActiveJob::Base

  include Rails.application.routes.url_helpers

  def perform(idea_id, user_id, activity_id)
    ActiveRecord::Base.connection_pool.with_connection do
      #Fetch records
      @user = User.find(user_id)
      @idea = Idea.find(idea_id)
      @activity = Activity.find(activity_id)

      #Increment counters for school and student
      @idea.school.ideas_counter.increment if @idea.school
      @idea.student.ideas_counter.increment if @idea.student
      #Cache latest ideas into a list for user and school, max: 20
      @idea.student.latest_ideas <<  @idea.id if @idea.student
      @idea.school.latest_ideas << @idea.id if @idea.school
      #Insert into cache list
      Idea.latest << @idea.id
      Idea.trending.add(@idea.id, 1)
      Idea.leaderboard.add(@idea.id, @idea.points)

      Pusher.trigger_async("ideas-channel",
        "new_idea",
        {data: idea_json(@idea)}.to_json
      )

      # Send notifications to followers
      User.find(@user.followers_ids.members).each do |f|
        Pusher.trigger_async("private-user-#{f.id}",
          "new_feed_item",
          {data: @activity.user.ticker.rangebyscore(@activity.created_at.to_i + @activity.id, @activity.created_at.to_i + @activity.id)}.to_json
        )

        #send mail to users if subscribed
        IdeaMailer.new_idea(@idea, @user, f).deliver_later if f.idea_notifications && f.idea_notifications == true
      end
    end
  end

  #Idea JSON
  def idea_json(idea)
    {
      id: idea.id,
      name: idea.name,
      name_badge: idea.name_badge,
      url: idea_path(idea),
      description: idea.elevator_pitch
    }
  end

end
