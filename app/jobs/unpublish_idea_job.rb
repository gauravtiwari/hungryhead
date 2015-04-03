class UnpublishIdeaJob < ActiveJob::Base
  queue_as :default

  def perform(idea)
   ActiveRecord::Base.connection_pool.with_connection do
  	PublicActivity::Activity.where(trackable_id: idea.id, trackable_type: "Idea").find_each do |activity|
       if activity && activity.published?
        activity.published = false
        activity.save!
        true
       end
    end

    if Mailboxer::Notification.where(notification_code: "idea_#{idea.id}").exists?
      Mailboxer::Notification.where(notification_code: "idea_#{idea.id}").find_each do |notification|
        notification.destroy
      end
    end
    
   end
  end
end
