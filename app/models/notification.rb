class Notification < ActiveRecord::Base
  include Feedable
  include NotificationRenderable

  public

  def self.mark_as_read(user_id)
    UpdateNotificationCacheService.new(user_id, self)
  end

end

