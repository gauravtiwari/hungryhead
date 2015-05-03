class DeleteUserFeedJob < ActiveJob::Base
  def perform(trackable_id, trackable_type)
    ActiveRecord::Base.connection_pool.with_connection do
      Activity.where(trackable_id: trackable_id, trackable_type: trackable_type).find_each do |activity|
        activity.user.latest_notifications.remrangebyscore(activity.created_at.to_i, activity.created_at.to_i)

        #Remove activity from follower and recipient
        find_followers(activity).each do |f|
          f.latest_notifications.remrangebyscore(activity.created_at.to_i, activity.created_at.to_i)
        end

        #Remove from idea feed if it's an idea activity
        if activity.recipient_type == "Idea"
          activity.recipient.latest_notifications.remrangebyscore(activity.created_at.to_i, activity.created_at.to_i)
        end

        #finally destroy the activity
        activity.destroy if activity.present?
      end
    end
  end

  #Get all followers followed by actor
  def find_followers(activity)
    followers_ids = activity.user.followers_ids.values
    rec_id = recipient_id(activity)
    followers = followers_ids.include?(rec_id.to_s) ? followers_ids : followers_ids.push(rec_id.to_s)
    User.find(followers)
  end

  #Get recipient id //user
  def recipient_id(activity)
    if activity.recipient_type == "User"
      activity.recipient.id
    elsif activity.recipient_type == "Idea"
      activity.recipient.student.id
    else
      activity.recipient.user.id
    end
  end

end