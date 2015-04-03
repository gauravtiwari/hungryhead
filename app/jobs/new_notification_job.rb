class NewNotificationJob < ActiveJob::Base

  def perform(user, object, type)
  	if type == "comment" && object.commentable_type == "Investment"
  		object_path = Rails.application.routes.url_helpers.idea_investment_path(object.commentable.idea.slug, object.commentable.id)+"#comment_#{object.id}"
    elsif type == "comment" && object.commentable_type == "Feedback"
      object_path = Rails.application.routes.url_helpers.idea_feedback_path(object.commentable.idea.slug, object.commentable.id)+"#comment_#{object.id}"
    elsif type == "comment" && object.commentable_type == "Status"
      object_path = Rails.application.routes.url_helpers.user_status_path(object.commentable.user.slug, object.commentable_id)+"#comment_#{object.id}"
    elsif type == "comment" && object.commentable_type == "Idea"
      object_path = Rails.application.routes.url_helpers.comments_idea_path(object.commentable.slug)+"#comment_#{object.id}"
  	elsif type == "status"
  		object_path = Rails.application.routes.url_helpers.user_status_path(object.user.slug, object.id)
  	elsif type == "feedback"
  		object_path = Rails.application.routes.url_helpers.idea_feedback_path(object.idea.slug, object.id)
  	elsif type == "investment"
  		object_path = Rails.application.routes.url_helpers.idea_investment_path(object.idea.slug, object.id)
  	end
    msg = "<a href='#{Rails.application.routes.url_helpers.profile_url(user)}'>#{user.name}</a> liked your "+ "<a href='#{object_path}'>#{type}</a>".html_safe
  
    notification = Notification.create!(
        reciever_id: object.user.id,
        sender_id: user.id,
        parameters: {
          verb: "liked",
          trackable: object.user.id,
          msg: msg,
          read: false
        }
    )

    Pusher.trigger("private-user-#{object.user.id}", "new_notification", {data: {id: notification.id, msg: msg } }.to_json)
  end
end
