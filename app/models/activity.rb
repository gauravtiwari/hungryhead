class Activity < ActiveRecord::Base

  include Renderable
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
  after_commit :cache_activities

  private

  def cache_activities
    user.latest_notifications.add(activity_json, created_at.to_i)
    if recipient_type == "Idea"
      recipient.latest_notifications.add(activity_json, created_at.to_i)
      Pusher.trigger_async("idea-feed-#{recipient_id}", "new_feed_item", {data: {id: id, item: recipient.latest_notifications.last}}.to_json)
    end
  end

  def activity_json
    mentioner = trackable.mentioner.class.to_s.downcase if trackable_type == "Mention"
    recipient_name = recipient_type == "Comment" ? recipient.user.name : recipient.name
    {
      actor: user.name,
      recipient: recipient_name,
      recipient_type: mentioner || nil,
      id: id,
      created_at: "#{created_at}",
      url: Rails.application.routes.url_helpers.profile_path(user),
      verb: verb
    }
  end

end
