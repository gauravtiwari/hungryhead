class Notification < ActiveRecord::Base
  include Feedable
  include NotificationsRenderable
end
