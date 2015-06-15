class PersistViewsCountJob < ActiveJob::Base

  def perform(user_id, id, type, referrer, ip)
    ActiveRecord::Base.connection_pool.with_connection do
      @user = User.find(user_id)
      @record = type.constantize.find(id)
      @record.impressions.create!(
        user: @user,
        referrer: referrer,
        ip_address: remote_ip,
        controller_name: type.pluralize,
        action_name: 'show'
      )
    end
  end

end
