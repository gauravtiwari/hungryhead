require 'render_anywhere'

class SendNotificationService

  include RenderAnywhere

  def initialize(recipient, activity)
    @recipient = recipient
    @activity = activity
  end

  def build_html
    root ||= "#{@activity.class.to_s.downcase.pluralize}"
    path ||= @activity.key.to_s.gsub('.', '/')
    partial_path =  select_path path, root
    render :partial => partial_path, locals: {activity: @activity}
  end

  def user_notification
    Pusher.trigger_async("private-user-#{@recipient.uid}",
      "new_ticker_item",
      {
        data:   build_html
      }.to_json
    )
    #Send counters updates
    Pusher.trigger_async("private-user-#{@recipient.uid}",
      "new_notifications_count",
      {
        data:   @recipient.notifications_counter.value
      }.to_json
    )
  end

  def idea_notification
    Pusher.trigger_async("idea-feed-#{@recipient.uuid}",
      "new_ticker_item",
      {
        data:   build_html
      }.to_json
    )
  end

  def friend_notification
    Pusher.trigger_async("private-user-#{@recipient.uid}",
      "new_friend_notification_item",
      {
        data:   build_html
      }.to_json
    )

    #send counters updates
    Pusher.trigger_async("private-user-#{@recipient.uid}",
      "new_notifications_count",
      {
        data:   @recipient.notifications_counter.value
      }.to_json
    )
  end

  private

  def select_path path, root
    [root, path].map(&:to_s).join('/')
  end

end