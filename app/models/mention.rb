class Mention < ActiveRecord::Base

  #Model relationships
  belongs_to :mentionable, polymorphic: true
  belongs_to :mentioner, polymorphic: true
  belongs_to :user

  #Model callbacks
  before_destroy :delete_notification, :decrement_counters
  after_create :increment_counters

  private

  def delete_notification
    DeleteUserNotificationJob.perform_later(self.id, self.class.to_s)
  end

  def increment_counters
    User.popular.increment(mentionable_id)
  end

  def decrement_counters
    User.popular.decrement(mentionable_id)
  end

end
