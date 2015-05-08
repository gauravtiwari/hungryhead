ActivityFeed.configure do |configuration|
  configuration.redis = $redis
  configuration.namespace = 'activity_feed'
  configuration.aggregate = false
  configuration.aggregate_key = 'aggregate'
  configuration.page_size = 25
  configuration.items_loader = Proc.new { |ids| Activity.where(id: ids).includes(:trackable, :user, :recipient).order(id: :desc).to_a }
end