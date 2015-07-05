class Activity < ActiveRecord::Base

  include IdentityCache
  #redis objects
  include Redis::Objects

  include Renderable
  include Feedable

  after_commit :cache_activity_to_redis, :delete_older_notifications, on: :create
  cache_index :uuid

  #Redis cache ids
  sorted_set :popular, global: true

  def cache_key
    "activities/activity-#{id}/user-#{user.id}-#{user_timestamp}/#{trackable_type}-#{trackable_id}-#{trackable_timestamp}"
  end

  def self.latest_stories
    where(published: true).includes([:trackable, :user]).order(id: :desc)
  end

  def self.popular_stories
    where(published: true).fetch_multi(Activity.popular.revrange(0, -1))
  end

  def trackable_timestamp
    trackable.updated_at.try(:utc).try(:to_s, :number)
  end

  def user_timestamp
    user.updated_at.try(:utc).try(:to_s, :number)
  end

  private

  def cache_activity_to_redis
    Activity.popular.add(id, score_key)
  end

  def score_key
    created_at.to_i + id
  end

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