class UnpublishUserJob < ActiveJob::Base
  queue_as :default

  def perform(user)
   ActiveRecord::Base.connection_pool.with_connection do
  	PublicActivity::Activity.where("activities.owner_id =? OR activities.recipient_id =?",user.id,user.id).where(owner_type: "User").find_each do |activity|
       if activity && activity.published?
        activity.published = false
        activity.save!
        true
      end
    end
    if user.ideas.exists? 
      user.ideas.find_each do |idea|
        idea.draft!
        idea.me!
      end
    end
   end
  end
end
