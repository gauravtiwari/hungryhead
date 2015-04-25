class Activity < PublicActivity::Activity

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

end
