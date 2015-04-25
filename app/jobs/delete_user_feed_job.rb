class DeleteUserFeedJob < ActiveJob::Base
  def perform(activity)
    @activity = activity
    ActiveRecord::Base.connection_pool.with_connection do
      User.find(@activity.owner.followers_ids.members).each do |follower|
        follower.latest_activities.delete({
          actor: @activity.owner.name,
          id: @activity.id,
          created_at: "#{@activity.created_at}",
          url: Rails.application.routes.url_helpers.profile_path(@activity.owner),
          verb: @activity.parameters[:verb],
          action: @activity.parameters[:action],
          recipient: @activity.recipient.name
        })
      end

      if @activity.recipient_type == "Idea"
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
      @activity.destroy if @activity.present?
    end
  end
end
