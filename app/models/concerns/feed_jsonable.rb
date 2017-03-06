require 'render_anywhere'

module FeedJsonable
  include RenderAnywhere
  extend ActiveSupport::Concern

  def json_blob
    {
      id: uuid,
      actor: {
        name: user.name
      },
      recipient: {
        name: recipient_user.name
      },
      type: get_type,
      updated_at: updated_at,
      activity_id: find_activity_id,
      html: build_html
    }
  end

  def build_html
    root ||= 'notifications'
    path ||= key.to_s.tr('.', '/')
    partial_path =  select_path path, root
    render partial: partial_path, locals: { activity: self }
  end

  private

  def get_type
    is_notification? ? 'Notification' : 'Activity'
  end

  def find_activity_id
    if is_notification?
      parent_id
    else
      uuid
    end
  end

  # Get path for notifications or activities
  def select_path(path, root)
    [root, path].map(&:to_s).join('/')
  end

  class RenderingController < RenderAnywhere::RenderingController
    attr_accessor :current_user
    helper_method :current_user

    def current_user
      User.current
    end
  end

  def rendering_controller
    @rendering_controller ||= self.class.const_get('RenderingController').new
  end
end
