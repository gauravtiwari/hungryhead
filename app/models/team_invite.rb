class TeamInvite < ActiveRecord::Base
  belongs_to :inviter, class_name: 'User', foreign_key: 'inviter_id'
  belongs_to :invited, class_name: 'User', foreign_key: 'invited_id'
  belongs_to :idea, touch: true
end
