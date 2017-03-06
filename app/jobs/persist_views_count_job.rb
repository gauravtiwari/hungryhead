class PersistViewsCountJob < ActiveJob::Base
  def perform(user_id, record_id, record_type, referrer, remote_ip)
    ActiveRecord::Base.connection_pool.with_connection do
      @user = User.find(user_id)
      @record = record_type.constantize.find(record_id)
      if @user.impressions.where(impressionable: @record).empty?
        record_type.constantize.trending.increment(@record.id)

        @user.impressions.create!(
          impressionable_id: record_id,
          impressionable_type: record_type,
          referrer: referrer,
          ip_address: remote_ip,
          controller_name: record_type.pluralize,
          action_name: 'show'
        )

        @record.views_counter.reset
        @record.views_counter.incr(Impression.where(impressionable: @record).size)

      else
        return false
      end
    end
  end
end
