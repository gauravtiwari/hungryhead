class NotificationCacheService

  def initialize(activity)
    @activity = activity
  end

  def cache
    @activity.user.latest_notifications.add(activity_json, @activity.created_at.to_i)
    if @activity.recipient_type == "Idea"
      cache_idea_notification
    end
  end

  def cache_idea_notification
    @activity.recipient.latest_notifications.add(activity_json, @activity.created_at.to_i)
    Pusher.trigger_async("idea-feed-#{@activity.recipient_id}",
      "new_feed_item",
      {
        data: @activity.recipient.latest_notifications.last
      }
    )
  end

  def activity_json
    mentioner = @activity.trackable.mentioner.class.to_s.downcase if @activity.trackable_type == "Mention"
    recipient_name = @activity.recipient_type == "Comment" ? @activity.recipient.user.name : @activity.recipient.name
    {
      actor: @activity.user.name,
      recipient: recipient_name,
      recipient_type: mentioner || nil,
      id: @activity.id,
      created_at: "#{@activity.created_at}",
      url: Rails.application.routes.url_helpers.profile_path(@activity.user),
      verb: @activity.verb
    }
  end

end