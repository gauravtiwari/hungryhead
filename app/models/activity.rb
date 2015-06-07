class Activity < ActiveRecord::Base

  include Renderable
  include Feedable

  after_commit :delete_older_notifications, on: :create

  def cache_key
    "activities/activity-#{id}/user-#{user.id}-#{user_timestamp}/#{trackable_type}-#{trackable_id}-#{trackable_timestamp}"
  end

  def trackable_timestamp
    trackable.updated_at.try(:utc).try(:to_s, :number)
  end

  def user_timestamp
    user.updated_at.try(:utc).try(:to_s, :number)
  end

  private

  def delete_older_notifications
    refresh_friends_notifications
    refresh_ticker
  end

  def refresh_ticker
    user.ticker.remrangebyrank(100, user.ticker.members.length)
  end

  def refresh_friends_notifications
    user.friends_notifications.remrangebyrank(50, user.friends_notifications.members.length)
  end

end
