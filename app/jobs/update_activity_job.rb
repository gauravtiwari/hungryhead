class UpdateActivityJob < ActiveJob::Base

  def perform(user_id)
    ActiveRecord::Base.connection_pool.with_connection do
      if User.find(user_id).present?
        @user = User.find(user_id)
        Activity.where(uuid: @user.ticker.members.map{|a| a[:id]}).find_each do |activity|
          "Update#{trackable_type}NotificationService".constantize.new(activity).update
        end
      else
        return false
      end
    end
  end

end