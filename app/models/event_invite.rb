class EventInvite < ActiveRecord::Base
  belongs_to :invited, class_name: 'User', foreign_key: 'invited_id'
  belongs_to :inviter, polymorphic: true
  belongs_to :event
end
