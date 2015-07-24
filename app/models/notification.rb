class Notification < ActiveRecord::Base

  after_commit :delete_older_notifications, on: :create

  include Feedable
  include FeedJsonable

  public

  def mark_as_read!
    self.unread = false
    self.save
  end

  private

  def delete_older_notifications
    refresh_friends_notifications
    refresh_ticker
    profile_latest_activities
  end

  def refresh_ticker
    owner.ticker.remrangebyrank(0, -100)
  end

  def refresh_friends_notifications
    owner.friends_notifications.remrangebyrank(0, -50)
  end

  def profile_latest_activities
    owner.latest_activities.remrangebyrank(0, -5)
  end

end

