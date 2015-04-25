PublicActivity::Activity.class_eval do

  after_create :cache_activities

  private

  def cache_activities
    becomes(Activity).cache_activities
  end

end
