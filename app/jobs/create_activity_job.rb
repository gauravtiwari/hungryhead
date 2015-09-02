class CreateActivityJob < ActiveJob::Base

  def perform(trackable_id, trackable_type)
    ActiveRecord::Base.connection_pool.with_connection do
      if trackable_type.constantize.where(id: trackable_id).empty?
        return false
      else
        @trackable = trackable_type.constantize.find(trackable_id)
        "Create#{trackable_type}NotificationService".constantize.new(@trackable).create
      end
    end
  end

end