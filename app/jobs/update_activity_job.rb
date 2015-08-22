class UpdateActivityJob < ActiveJob::Base

  def perform(user_id)
    ActiveRecord::Base.connection_pool.with_connection do
      if User.find(user_id).present?
        @user = User.find(user_id)
        Activity.where(user: @user).find_each do |activity|
          UpdateNotificationCacheService.new(activity).update
        end
      else
        return false
      end
    end
  end

end