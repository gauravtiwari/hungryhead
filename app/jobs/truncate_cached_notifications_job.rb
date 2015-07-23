class TruncateCachedNotificationsJob < ActiveJob::Base

  def perform(user_id)
    ActiveRecord::Base.connection_pool.with_connection do
      @user = User.find(user_id)

      #Truncate user feeds in redis sorted set
      @user.ticker.remrangebyrank(0, -100)
      @user.friends_notifications.remrangebyrank(0, -50)
      @user.latest_activities.remrangebyrank(0, -5)

    end
  end

end