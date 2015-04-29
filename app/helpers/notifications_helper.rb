module NotificationsHelper
  def render_notification notifications, options = {}
    if notifications.is_a? Notification
      notifications.render self, options
    elsif notifications.respond_to?(:map)
      return nil if notifications.empty?
      notifications.map {|notification| notification.render self, options.dup }.join.html_safe
    end
  end

  alias_method :render_notifications, :render_notification

  def single_content_for(name, content = nil, &block)
    @view_flow.set(name, ActiveSupport::SafeBuffer.new)
    content_for(name, content, &block)
  end

end
