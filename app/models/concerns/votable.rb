module Votable

  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, :dependent => :destroy
  end

  def voted?(user)
    voters_ids.values.include?(user.id.to_s)
  end

  def find_voters
    User.fetch_multi(voters_ids.values)
  end

end