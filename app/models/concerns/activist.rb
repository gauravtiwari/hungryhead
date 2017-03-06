module Activist
  extend ActiveSupport::Concern
  included do
    has_many :activities_as_recipient,
             class_name: 'Activity',
             as: :recipient
    has_many :notifications_as_recipient,
             class_name: 'Notification',
             as: :recipient
  end
end
