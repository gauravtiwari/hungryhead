class CacheUserActivityService

  def initialize(activity)
    @activity = activity
  end

  def create_redis_cache
   @activity.owner.activities_ids.add(@activity.id, @activity.created_at.to_i)
   @user_feed = @activity.owner.latest_activities.add({
     actor: @activity.owner.name,
     id: @activity.id,
     created_at: "#{@activity.created_at}",
     url: Rails.application.routes.url_helpers.profile_path(@activity.owner),
     verb: @activity.parameters[:verb],
     action: @activity.parameters[:action],
     recipient: @activity.recipient.name
   }, @activity.created_at.to_i)

   Pusher.trigger("user-feed-#{@activity.recipient_id}", "new_feed_item", {data: {id: @activity.id, item: @user_feed } }.to_json)
  end

  def delete_redis_cache
    @activity.owner.activities_ids.delete(@activity.id)
    @activity.owner.latest_activities.delete({
      actor: @activity.owner.name,
      id: @activity.id,
      created_at: "#{@activity.created_at}",
      url: Rails.application.routes.url_helpers.profile_path(@activity.owner),
      verb: @activity.parameters[:verb],
      action: @activity.parameters[:action],
      recipient: @activity.owner.name
    })
  end

end
