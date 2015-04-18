class Activity < PublicActivity::Activity

  def cache_activities
    if recipient_type == "User"
      @user_feed = owner.latest_activities << {
        actor: owner.name,
        id: id,
        created_at: "#{created_at}",
        url: Rails.application.routes.url_helpers.profile_path(owner),
        verb: parameters[:verb],
        action: parameters[:action],
        recipient: recipient.name
      }
      Pusher.trigger("feed-#{recipient_id}", "new_feed_item", {data: {id: id, item: @user_feed } }.to_json)

    elsif recipient_type == "Idea"
      @idea_feed = recipient.latest_activities << {
        actor: owner.name,
        id: id,
        created_at: "#{created_at}",
        url: Rails.application.routes.url_helpers.profile_path(owner),
        verb: parameters[:verb],
        action: parameters[:action],
        recipient: recipient.name
      }
      Pusher.trigger("feed-#{recipient_id}", "new_feed_item", {data: {id: id, item: @idea_feed }}.to_json)
    end
  end

  def delete_cached_activities
    if recipient_type == "User"
      @user_feed = owner.latest_activities.delete({
        actor: owner.name,
        id: id,
        created_at: "#{created_at}",
        url: Rails.application.routes.url_helpers.profile_path(owner),
        verb: parameters[:verb],
        action: parameters[:action],
        recipient: recipient.name
      })
    elsif recipient_type == "Idea"
      @idea_feed = recipient.latest_activities.delete({
        actor: owner.name,
        id: id,
        created_at: "#{created_at}",
        url: Rails.application.routes.url_helpers.profile_path(owner),
        verb: parameters[:verb],
        action: parameters[:action],
        recipient: recipient.name
      })
    end
  end

end
