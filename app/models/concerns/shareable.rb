module Shareable
  extend ActiveSupport::Concern

  included do
    has_many :shares, as: :shareable, dependent: :destroy, autosave: true
  end

  module ClassMethods
    def shared?(user)
      sharers_ids.members.include?(user.id.to_s)
    end

    def sharers
      User.find(sharers_ids.members)
    end
  end

end