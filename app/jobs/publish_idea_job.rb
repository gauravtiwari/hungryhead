class PublishIdeaJob < ActiveJob::Base

  def perform(idea_id, user_id, activity_id)
    ActiveRecord::Base.connection_pool.with_connection do
      #Fetch records
      @user = User.find(user_id)
      @idea = Idea.find(idea_id)
      @activity = Activity.find(activity_id)
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

end
