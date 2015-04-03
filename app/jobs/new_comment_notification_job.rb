class NewCommentNotificationJob < ActiveJob::Base

  def perform(user, object, type)
    if object.commentable.class.to_s == "Investment"
      object_path = Rails.application.routes.url_helpers.idea_investment_url(object.commentable.idea.slug, object.commentable.id, host: 'localhost', port: 3000)
    elsif object.commentable.class.to_s == "Feedback"
      object_path = Rails.application.routes.url_helpers.idea_feedback_url(object.commentable.idea.slug, object.commentable.id, host: 'localhost', port: 3000)
    elsif object.commentable.class.to_s == "Idea"
      object_path = Rails.application.routes.url_helpers.comments_idea_url(object.commentable, host: 'localhost', port: 3000)
    elsif object.commentable.class.to_s == "Status"
      object_path = Rails.application.routes.url_helpers.user_status_url(object.commentable.user.slug, object.commentable.id, host: 'localhost', port: 3000)
    end

    msg = "<a href='#{Rails.application.routes.url_helpers.profile_url(user, host: 'localhost', port: 3000)}'>#{user.name}</a> commented on your "+ "<a href='#{object_path}'>#{type}</a>".html_safe

    notification = Notification.create!(
      reciever_id: object.commentable.user.id,
      sender_id: user.id,
      parameters: {
        verb: "commented",
        trackable_id: object.commentable.id,
        trackable_type: object.commentable.class.to_s,
        msg: msg,
        type: type,
        read: false
      }
    )
    Pusher.trigger("private-user-#{object.commentable.user.id}", "new_notification", {data: {id: notification.id, msg: msg } }.to_json)
  end
end
