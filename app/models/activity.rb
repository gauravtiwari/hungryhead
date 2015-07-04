class Activity < ActiveRecord::Base

  include IdentityCache
  include Renderable
  include Feedable

  cache_index :uuid

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
    profile_latest_activities
  end

  def refresh_ticker
    user.ticker.remrangebyrank(0, -100)
  end

  def refresh_friends_notifications
    user.friends_notifications.remrangebyrank(0, -50)
  end

  def profile_latest_activities
    user.latest_activities.remrangebyrank(0, -5)
  end

end