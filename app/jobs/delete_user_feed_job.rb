class DeleteUserFeedJob < ActiveJob::Base
  def perform(trackable_id, trackable_type)
    ActiveRecord::Base.connection_pool.with_connection do
      Activity.where(trackable_id: trackable_id, trackable_type: trackable_type).find_each do |activity|
        activity.user.latest_notifications.delete(activity_json(activity))
        if activity.recipient_type == "Idea"
          recipient.latest_notifications.add(activity_json(activity))
        end
        activity.destroy if activity.present?
      end
    end
  end

  def activity_json(activity)
    mentioner = activity.trackable.mentioner.class.to_s.downcase if activity.trackable_type == "Mention"
    recipient_name = activity.recipient_type == "Comment" ? activity.recipient.user.name : activity.recipient.name
    {
      actor: activity.user.name,
      recipient: recipient_name,
      recipient_type: mentioner || nil,
      id: activity.id,
      created_at: "#{activity.created_at}",
      url: Rails.application.routes.url_helpers.profile_path(activity.user),
      verb: activity.verb
    }
  end

end
