class Activity < ActiveRecord::Base

  # Define polymorphic association to the parent
  belongs_to :trackable, :polymorphic => true
  # Define ownership to a resource responsible for this activity
  belongs_to :user
  # Define ownership to a resource targeted by this activity
  belongs_to :recipient, :polymorphic => true
  # Serialize parameters Hash
  serialize :parameters, HashSerializer

  #Serialize JSON
  store_accessor :parameters, :verb, :meta

  #reading notifications and activities
  acts_as_readable :on => :created_at

  #Model callbacks
  after_create :cache_activities

  private

  def cache_activities
    UpdateUserFeedJob.perform_later(self)
    if recipient_type == "Idea"
      recipient.latest_activities.add(id, created_at.to_i)
      Pusher.trigger_async("idea-feed-#{recipient_id}", "new_feed_item", {data: {id: id, item: recipient.latest_activities.last}}.to_json)
    end
  end

end
