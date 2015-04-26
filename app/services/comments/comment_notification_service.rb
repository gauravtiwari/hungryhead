require 'render_anywhere'
class CommentNotificationService
  include RenderAnywhere

	def initialize(comment, commentable)
		@comment = comment
		@user = comment.user
		@commentable = commentable
	end

	def notify
    @activity = @user.activities.create!(trackable: @comment, type: 'Notification', recipient: @commentable, verb: 'commented', key: 'comment.create')
    send_notification(@activity)
	end

  private

  def send_notification(activity)
    activity.recipient.commenters.each do |user|
      Pusher.trigger("private-user-#{user}",
        "new_feed_item",
        { data: activity.user.latest_activities.last}
      )
    end
  end

end