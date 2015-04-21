class PostInvestmentJob < ActiveJob::Base

  def perform(investment, user, object_path, idea_path, user_url)
   ActiveRecord::Base.connection_pool.with_connection do

	msg = "<a href='#{user_url}'>#{user.name}</a> made a <i class='fa fa-fw fa-dollar'></i> #{investment.amount} "+ "<a href='#{object_path}'>investment</a> in <a href='#{idea_path}'>#{investment.idea.name}</a>".html_safe

	followers = investment.idea.followers_ids.members.push(investment.idea.student.id)
  all = followers.delete(user.id)
  if all
    User.find(all).each do |f|
  		notification = Notification.create!(
  	        reciever_id: f.id,
  	        sender_id: user.id,
  	        parameters: {
  	          verb: "invested",
  	          trackable: investment.id,
  	          msg: msg,
  	          read: false
  	        }
  	    )
  		Pusher.trigger("private-user-#{f.id}", "new_notification", {data: {id: notification.id, msg: msg } }.to_json)
    end
  end

	end
  end
end
