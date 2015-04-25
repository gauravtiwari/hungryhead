class PublishIdeaJob < ActiveJob::Base

  def perform(idea_id, user_id, activity_id)
    ActiveRecord::Base.connection_pool.with_connection do
      #Fetch records
      @user = User.find(user_id)
      @idea = Idea.find(idea_id)
      @activity = Activity.find(activity_id)
      # Send notifications to followers
      User.find(@user.followers_ids.members).each do |f|
        Pusher.trigger("private-user-#{f.id}",
          "new_notification",
          {data:
            {
              id: @activity.id,
              msg: render(json: ActivityPresenter.new(@activity))
            }
          }.to_json
        )
        #send mail to users if subscribed
        IdeaMailer.new_idea(@idea, @user, f).deliver_later if f.idea_notifications && f.idea_notifications?
      end
    end
  end

end
