module Sharings
  extend ActiveSupport::Concern

  included do
    has_many :shares, as: :shareable, dependent: :destroy
  end

  public

  def shared?(user)
    sharers_ids.values.include?(user.id.to_s)
  end

end