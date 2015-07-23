class Activity < ActiveRecord::Base

  #redis objects
  include Redis::Objects

  include Renderable
  include Feedable

  after_commit :cache_activity_to_redis, :delete_older_notifications, on: :create

  #Redis cache ids
  sorted_set :popular, global: true

  def cache_key
    "activities/activity-#{id}/owner-#{owner.id}-#{owner_timestamp}/#{trackable_type}-#{trackable_id}-#{trackable_timestamp}"
  end

  def self.latest_stories
    where(published: true).includes([:trackable, :owner]).order(id: :desc)
  end

  def self.popular_stories
    includes([:trackable, :owner]).find(Activity.popular.revrange(0, -1)).select{|activity| activity.published? }
  end

  def trackable_timestamp
    trackable.updated_at.try(:utc).try(:to_s, :number)
  end

  def owner_timestamp
    owner.updated_at.try(:utc).try(:to_s, :number)
  end

  private

  def cache_activity_to_redis
    Activity.popular.add(id, id)
  end

  def delete_older_notifications
    unless owner_type == "School"
      refresh_friends_notifications
      refresh_ticker
      profile_latest_activities
    end
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