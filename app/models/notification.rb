class Notification < ActiveRecord::Base
  include Feedable

  public

  def self.mark_as_read(user_id)
    UpdateNotificationCacheService.new(user_id, self)
  end

end

