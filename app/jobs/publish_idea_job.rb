class PublishIdeaJob < ActiveJob::Base

  include Rails.application.routes.url_helpers

  def perform(idea_id, user_id, activity_id)

    ActiveRecord::Base.connection_pool.with_connection do
      #Fetch records
      @user = User.find(user_id)
      @idea = Idea.find(idea_id)
      @activity = Activity.find(activity_id)
      @school = School.find(@idea.school_id)

      #Rebuild counters for school
      @school.ideas_counter.reset
      @school.ideas_counter.incr(@school.get_published_ideas.length)

      #Rebuild counters for user
      @user.ideas_counter.reset
      @user.ideas_counter.incr(@user.published_ideas.length)

      #Cache  ideas into a list/sorted_Set for user and school
      @school.published_ideas.add(@idea.id, @idea.created_at.to_i + @idea.id)

      #Insert into cache list
      Idea.latest.add(@idea.id, @idea.created_at.to_i + @idea.id)
      Idea.trending.add(@idea.id, @idea.impressions.length)
      Idea.leaderboard.add(@idea.id, @idea.points)

      #Pusher notification for new idea
      Pusher.trigger_async("ideas-channel",
        "new_idea",
        {data: idea_json(@idea)}.to_json
      )

      #Fetch followings from cache
      @user.followings.create!(followable: @idea) if @user.followings.select{|follow| follow.followable_type == "Idea" && follow.followable_id == @idea.id}.empty?

      # Send notifications to followers
      User.find(@user.followers_ids.members).each do |f|
        #Send notifications to followers
        Pusher.trigger_async("private-user-#{f.uid}",
          "new_ticker_item",
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
      description: idea.high_concept_pitch
    }
  end

end
