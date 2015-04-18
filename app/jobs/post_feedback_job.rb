class PostFeedbackJob < ActiveJob::Base

  def perform(feedback, user, object_path, idea_path, user_url)
   ActiveRecord::Base.connection_pool.with_connection do

    feedback.idea.feedbackers.push(user.id)
  	feedback.idea.save

	msg = "<a href='#{user_url}'>#{user.name}</a> left a "+ "<a href='#{object_path}'>feedback <i class='fa fa-fw ion-chatbubbles'></i> </a> for <a href='#{idea_path}'>#{feedback.idea.name}</a> ".html_safe

	followers = user.followers_by_type('User')
	all = followers.push(feedback.idea.student)

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
