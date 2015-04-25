class Activity < ActiveRecord::Base

  # Define polymorphic association to the parent
  belongs_to :trackable, :polymorphic => true
  # Define ownership to a resource responsible for this activity
  belongs_to :owner, :polymorphic => true
  # Define ownership to a resource targeted by this activity
  belongs_to :recipient, :polymorphic => true
  # Serialize parameters Hash
  serialize :parameters, HashSerializer

  #Serialize JSON
  store_accessor :parameters, :verb, :meta

  #Model callbacks
  after_create :cache_activities
  before_destroy :delete_cached_activities

  private

  def cache_activities
    UpdateUserFeedJob.perform_later(self)
    if recipient_type == "Idea"
      @activity = self
      @activity.recipient.latest_activities.add({
        actor: @activity.owner.name,
        id: @activity.id,
        created_at: "#{@activity.created_at}",
        url: Rails.application.routes.url_helpers.profile_path(@activity.owner),
        verb: @activity.parameters[:verb],
        action: @activity.parameters[:action],
        recipient: @activity.recipient.name
      }, @activity.created_at.to_i)
      Pusher.trigger_async("idea-feed-#{@activity.recipient_id}", "new_feed_item", {data: {id: @activity.id, item: @activity.recipient.latest_activities.last}}.to_json)
    end
  end

  def delete_cached_activities
    DeleteUserFeedJob.perform_later(self)
    if recipient_type == "Idea"
      @activity = self
      @activity.recipient.latest_activities.delete({
         actor: @activity.owner.name,
         id: @activity.id,
         created_at: "#{@activity.created_at}",
         url: Rails.application.routes.url_helpers.profile_path(@activity.owner),
         verb: @activity.parameters[:verb],
         action: @activity.parameters[:action],
         recipient: @activity.recipient.name
       })
    end
  end


end
