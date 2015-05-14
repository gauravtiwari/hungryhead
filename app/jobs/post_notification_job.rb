class PostNotificationJob < ActiveJob::Base

  def perform(post_id, user_id, activity_id)
    ActiveRecord::Base.connection_pool.with_connection do
      #Fetch records
      @user = User.find(user_id)
      @post = Post.find(post_id)
      @activity = Activity.find(activity_id)
      # Send notifications to followers
      User.find(@user.followers_ids.members).each do |f|
        #Calll notification service to deliver the notification to followers
        SendNotificationService.new(@user, @activity).user_notification
        #send mail to users if subscribed
        PostMailer.new_post(@post, @user, f).deliver_later if f.post_notifications && f.post_notifications == true
      end
    end
  end

end
