module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, class_name: 'Vote', dependent: :destroy
  end

  def voted?(user)
    voters_ids.values.include?(user.id.to_s)
  end

  def get_voters
    User.find(voters_ids.values)
  end
end
