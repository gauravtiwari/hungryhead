module Votable

  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, :dependent => :destroy
  end

  module ClassMethods
    def voted?(user)
      voters_ids.members.include?(user.id.to_s)
    end

    def voters
      User.find(voters_ids.members)
    end
  end

end