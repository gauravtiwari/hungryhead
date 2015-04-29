class Mention < ActiveRecord::Base

  #Model relationships
  belongs_to :mentionable, polymorphic: true
  belongs_to :mentioner, polymorphic: true
  belongs_to :user

  #Model callbacks
  before_destroy :delete_notification

  private

  def delete_notification
    DeleteUserNotificationJob.perform_later(self.id, self.class.to_s)
  end

end
