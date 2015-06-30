class Activity < ActiveRecord::Base

  include IdentityCache
  include Renderable
  include Feedable

  after_commit :truncate_cached_notifications, on: :create
  cache_belongs_to :user

  def cache_key
    "activities/activity-#{id}/user-#{user_id}-#{user_timestamp}/#{trackable_type}-#{trackable_id}-#{trackable_timestamp}"
  end

  def trackable_timestamp
    trackable.updated_at.try(:utc).try(:to_s, :number)
  end

  def user_timestamp
    fetch_user.updated_at.try(:utc).try(:to_s, :number)
  end

  private

  def truncate_cached_notifications
    TruncateCachedNotificationsJob.perform_later(user_id)
  end

end
