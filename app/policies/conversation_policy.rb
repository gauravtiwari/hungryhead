class ConversationPolicy < ApplicationPolicy
  def create?
    current_user.follower?(record.user)
  end
end

