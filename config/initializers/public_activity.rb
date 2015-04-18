PublicActivity::Activity.class_eval do

  after_create :cache_activities
  before_destroy :delete_cached_activities

  private

  def cache_activities
    becomes(Activity).cache_activities
  end

  def delete_cached_activities
    becomes(Activity).delete_cached_activities
  end

end
