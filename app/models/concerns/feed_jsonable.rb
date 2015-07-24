require 'render_anywhere'

module FeedJsonable

  include RenderAnywhere
  extend ActiveSupport::Concern

  def json_blob
    {
      id: id,
      type: self.class.to_s,
      activity_id: find_activity_id,
      html: build_html
    }
  end

  def build_html
    root ||= "notifications"
    path ||= key.to_s.gsub('.', '/')
    partial_path =  select_path path, root
    render :partial => partial_path, locals: {activity: self}
  end

  private

  def find_activity_id
    if self.class.to_s == "Notification"
      return parent_id
    else
      return uuid
    end
  end

  #Get path for notifications or activities
  def select_path path, root
    [root, path].map(&:to_s).join('/')
  end

end