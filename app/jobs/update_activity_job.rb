class UpdateActivityJob < ActiveJob::Base
  def perform(user_id)
    ActiveRecord::Base.connection_pool.with_connection do
      if User.where(id: user_id).empty?
        return false
      else
        @user = User.find(user_id)
        Activity.where(user: @user).find_each do |activity|
          # Update cached activity if trackable/actor updated
          UpdateNotificationCacheService.new(activity).update
        end
      end
    end
  end
end
