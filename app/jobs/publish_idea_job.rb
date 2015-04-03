class PublishIdeaJob < ActiveJob::Base
	
  def perform(idea, user)
   ActiveRecord::Base.connection_pool.with_connection do
   	#Publish idea activity
   	if PublicActivity::Activity.where(trackable_id: idea.id, key: "idea.create").exists?
	   	PublicActivity::Activity.where(trackable_id: idea.id, trackable_type: "Idea").find_each do |activity|
	       if activity && !activity.published?
	        activity.published = true
	        activity.save!
	        true
	       end
	    end
	else

   	idea.create_activity(key: 'idea.create', owner: user, recipient: user)

   	object_path = Rails.application.routes.url_helpers.idea_url(idea, host: 'localhost', port: 3000)
	msg = "<a href='#{Rails.application.routes.url_helpers.profile_url(user)}'>#{user.name}</a> published <i class='fa fa-fw ion-briefcase'></i> "+ "<a href='#{object_path}'>#{idea.name}</a>".html_safe

   	user.followings.each do |f|
		notification = Notification.create!(
	        reciever_id: f.id,
	        sender_id: user.id,
	        parameters: {
	          verb: "published",
	          trackable: idea.id,
	          msg: msg,
	          read: false
	        }
	    )
		Pusher.trigger("private-user-#{f.id}", "new_notification", {data: {id: notification.id, msg: msg } }.to_json)
    end

   end

   	#Load the idea into soulmate
   	loader = Soulmate::Loader.new("ideas")
	image =  idea.logo.url(:mini)
	loader.add("term" => idea.name, "image" => image, "description" => idea.high_concept_pitch, "id" => idea.id, "data" => {
	    "link" => Rails.application.routes.url_helpers.idea_path(idea)
	})
	end
  end
end
