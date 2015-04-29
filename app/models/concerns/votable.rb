module Votable

  extend ActiveSupport::Concern
  included do
    has_many :votes, as: :votable, :dependent => :destroy
  end

  def voted?(user)
    voters_ids.members.include?(user.id.to_s)
  end

end