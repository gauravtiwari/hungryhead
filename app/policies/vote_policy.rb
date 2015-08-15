class VotePolicy < ApplicationPolicy

  def vote?
    true
  end

  def unvote?
    current_user == record.voter
  end

  def voters?
    true
  end

end

