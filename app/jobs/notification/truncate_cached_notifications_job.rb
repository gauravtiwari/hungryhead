class TruncateCachedNotificationsJob < ActiveJob::Base

  def perform(user_id)
    ActiveRecord::Base.connection_pool.with_connection do
      @user = User.fetch(id)

      #Truncate user feeds in redis sorted set
      @user.ticker.remrangebyrank(100, @user.ticker.members.length)
      @user.friends_notifications.remrangebyrank(50, @user.friends_notifications.members.length)
      @user.latest_activities.remrangebyrank(5, @user.latest_activities.members.length)

    end
  end

end