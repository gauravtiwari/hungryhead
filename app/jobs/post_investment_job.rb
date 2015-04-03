class PostInvestmentJob < ActiveJob::Base
	
  def perform(investment, user)
   ActiveRecord::Base.connection_pool.with_connection do
   	#Post feedback activity
   	investment.create_activity(key: 'investment.create', 
   		owner: user, 
   		recipient: investment.idea
   	)

   	object_path = Rails.application.routes.url_helpers.idea_investment_url(investment.idea, investment.id,  host: 'localhost', port: 3000)
   	idea_path = Rails.application.routes.url_helpers.idea_url(investment.idea,  host: 'localhost', port: 3000)
	
	msg = "<a href='#{Rails.application.routes.url_helpers.profile_url(user)}'>#{user.name}</a> made a <i class='fa fa-fw fa-dollar'></i> #{investment.amount} "+ "<a href='#{object_path}'>investment</a> in <a href='#{idea_path}'>#{investment.idea.name}</a>".html_safe

	followers = user.followers_by_type('User')
	all = followers.push(investment.idea.user)

   	all.each do |f|
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
