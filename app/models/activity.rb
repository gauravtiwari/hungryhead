class Activity < ActiveRecord::Base
  extend OrderAsSpecified

  include Redis::Objects
  include Feedable
  include FeedJsonable

  after_commit :cache_activity_to_redis, :delete_older_notifications, on: :create

  sorted_set :popular, global: true

  def cache_key
    "activities/activity-#{id}/user-#{user.id}-#{user_timestamp}/#{trackable_type}-#{trackable_id}-#{trackable_timestamp}"
  end

  def self.latest_stories
    where(published: true, is_notification: false).find_each.sort { |a, b| b.created_at <=> a.created_at }
  end

  def self.popular_stories
    where(published: true, is_notification: false).find(Activity.popular.revrange(0, -1)).sort { |a, b| b.created_at <=> a.created_at }
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

  def recipient_user
    if recipient.present?
      if recipient_type == 'User'
        recipient
      else
        recipient.user
      end
    end
  end

  private

  def cache_activity_to_redis
    Activity.popular.add(id, id)
  end

  def delete_older_notifications
    refresh_friends_notifications unless user_type == 'School'
  end

  def refresh_friends_notifications
    user.friends_notifications.remrangebyrank(0, -50)
  end
end
