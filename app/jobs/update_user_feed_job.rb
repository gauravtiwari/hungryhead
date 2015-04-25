class UpdateUserFeedJob < ActiveJob::Base
  def perform(activity)
    @activity = activity
    ActiveRecord::Base.connection_pool.with_connection do
      User.find(@activity.owner.followers_ids.members).each do |follower|
        follower.latest_activities.add({
          actor: @activity.owner.name,
          id: @activity.id,
          created_at: "#{@activity.created_at}",
          url: Rails.application.routes.url_helpers.profile_path(@activity.owner),
          verb: @activity.parameters[:verb],
          action: @activity.parameters[:action],
          recipient: @activity.recipient == @activity.owner ? "You" : @activity.recipient.name
        }, @activity.created_at.to_i)

        #trigger pusher live update
        Pusher.trigger("user-feed-#{follower.id}",
         "new_feed_item",
           {data:
             {
               id: follower.id,
               item: follower.latest_activities.last
             }
           }.to_json
        )
      end
    end
  end
end
