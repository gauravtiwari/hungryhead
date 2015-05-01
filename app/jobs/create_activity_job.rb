class CreateActivityJob < ActiveJob::Base
  def perform(trackable_id, trackable_type)
    ActiveRecord::Base.connection_pool.with_connection do
      @trackable = trackable_type.constantize.find(trackable_id)
      "Create#{trackable_type}NotificationService".constantize.new(@trackable).create unless trackable_type == "Follow" && @trackable.followable.class.to_s == "School"
    end
  end
end