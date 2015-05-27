class Mention < ActiveRecord::Base

  #Model relationships
  belongs_to :mentionable, polymorphic: true, touch: true
  belongs_to :mentioner, polymorphic: true, touch: true
  belongs_to :user, touch: true

  #Model callbacks
  before_destroy :delete_notification

  private

  def delete_notification
    #Delete notification
    DeleteUserNotificationJob.set(wait: 5.seconds).perform_later(self.id, self.class.to_s)
  end

end
