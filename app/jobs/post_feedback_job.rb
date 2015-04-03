class PostFeedbackJob < ActiveJob::Base
	
  def perform(feedback, user)
   ActiveRecord::Base.connection_pool.with_connection do
    
    feedback.idea.feedbackers.push(user.id)
  	feedback.idea.save

   	#Publish feedback activity

   	feedback.create_activity(key: 'feedback.create', 
   		owner: user, 
   		recipient: feedback.idea
   	)

   	object_path = Rails.application.routes.url_helpers.idea_feedback_url(feedback.idea, feedback.id,  host: 'localhost', port: 3000)
	idea_path = Rails.application.routes.url_helpers.idea_url(feedback.idea,  host: 'localhost', port: 3000)
	
	msg = "<a href='#{Rails.application.routes.url_helpers.user_url(user)}'>#{user.name}</a> left a "+ "<a href='#{object_path}'>feedback <i class='fa fa-fw ion-chatbubbles'></i> </a> for <a href='#{idea_path}'>#{feedback.idea.name}</a> ".html_safe

	followers = user.followers_by_type('User')
	all = followers.push(feedback.idea.user)

   	all.each do |f|
		notification = Notification.create!(
	        reciever_id: f.id,
	        sender_id: user.id,
	        parameters: {
	          verb: "feedbacked",
	          trackable: feedback.id,
	          msg: msg,
	          read: false
	        }
	    )
		Pusher.trigger("private-user-#{f.id}", "new_notification", {data: {id: notification.id, msg: msg } }.to_json)
    end

	end
  end
end
