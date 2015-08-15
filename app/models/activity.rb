class Activity < ActiveRecord::Base

  extend OrderAsSpecified
  #redis objects
  include Redis::Objects
  include Feedable
  include FeedJsonable

  after_commit :cache_activity_to_redis, :delete_older_notifications, on: :create

  #Redis cache ids
  sorted_set :popular, global: true

  def cache_key
    "activities/activity-#{id}/user-#{user.id}-#{user_timestamp}/#{trackable_type}-#{trackable_id}-#{trackable_timestamp}"
  end

  def self.latest_stories
    where(published: true, is_notification: false).find_each.sort {|a,b| b.created_at <=> a.created_at}
  end

  def self.popular_stories
    where(published: true, is_notification: false).find(Activity.popular.revrange(0, -1)).sort {|a,b| b.created_at <=> a.created_at}
  end

  def self.get_activities
    where(published: true, is_notification: false)
  end

  def trackable_timestamp
    trackable.updated_at.try(:utc).try(:to_s, :number)
  end

  def user_timestamp
    user.updated_at.try(:utc).try(:to_s, :number)
  end

  #Find recipient user
  def recipient_user
    byebug
    if recipient_type == "User"
      recipient
    elsif user_type == "School"
      trackable.user.user
    else
      recipient.user
    end
  end

  private

  def cache_activity_to_redis
    Activity.popular.add(id, id)
  end

  def delete_older_notifications
    unless user_type == "School"
      refresh_friends_notifications
      refresh_ticker
    end
  end

  def refresh_ticker
    user.ticker.remrangebyrank(0, -100)
  end

  def refresh_friends_notifications
    user.friends_notifications.remrangebyrank(0, -50)
  end

end