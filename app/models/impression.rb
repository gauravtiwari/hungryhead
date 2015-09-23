class Impression < ActiveRecord::Base

  belongs_to :user, -> {with_deleted}
  belongs_to :impressionable, -> {with_deleted}, polymorphic: true, touch: true

  after_commit :cache_impression, on: :create
  before_destroy :delete_cached_impression

  private

  def cache_impression
    impressionable.impressioners_ids.add(user_id)
  end

  def delete_cached_impression
    impressionable.impressioners_ids.delete(user_id)
    true
  end

end
