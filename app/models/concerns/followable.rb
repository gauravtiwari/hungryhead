module Followable
  extend ActiveSupport::Concern

  included do
    has_many :followers, as: :followable, class_name: 'Follow', dependent: :destroy
  end

  def followed?(user)
    followers_ids.members.include? used.id.to_s
  end

end