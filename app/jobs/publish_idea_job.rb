class PublishIdeaJob < ActiveJob::Base

  include Rails.application.routes.url_helpers

  def perform(idea_id, user_id, activity_id)
    ActiveRecord::Base.connection_pool.with_connection do
      #Fetch records
      @user = User.find(user_id)
      @idea = Idea.find(idea_id)
      @activity = Activity.find(activity_id)

      #Increment counters for school and user
      @idea.school.ideas_counter.increment
      @user.ideas_counter.increment
      #Cache latest ideas into a list for user and school, max: 20
      @user.latest_ideas <<  @idea.id
      @idea.school.latest_ideas << @idea.id
      #Insert into cache list
      Idea.latest << @idea.id
      Idea.trending.add(@idea.id, 1)
      Idea.leaderboard.add(@idea.id, @idea.points)

      Pusher.trigger_async("ideas-channel",
        "new_idea",
        {data: idea_json(@idea)}.to_json
      )

      @user.followings.create!(followable: @followable)

      # Send notifications to followers
      User.find(@user.followers_ids.members).each do |f|
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
