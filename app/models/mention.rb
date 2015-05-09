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
    #Delete notification
    DeleteUserNotificationJob.perform_later(self.id, self.class.to_s)
  end

  def increment_counters
    #increment popularity score
    User.popular.increment(mentionable.user_json) if mentionable_type == "User"
  end

  def decrement_counters
    #decrement popularity score
    User.popular.decrement(mentionable.user_json) if mentionable_type == "User"
  end

end
