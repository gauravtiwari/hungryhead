class Impression < ActiveRecord::Base

  # Associations
  belongs_to :user
  belongs_to :impressionable, polymorphic: true, touch: true

  # Callbacks
  after_commit :cache_impression, on: :create
  before_destroy :delete_cached_impression

  private

  # Cache/Delete impressions from Redis
  def cache_impression
    impressionable.impressioners_ids.add(user_id)
  end

  def delete_cached_impression
    impressionable.impressioners_ids.delete(user_id)
    true
  end

end
