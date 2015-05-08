module Sharings
  extend ActiveSupport::Concern

  included do
    has_many :shares, as: :shareable, dependent: :destroy
    cache_has_many :shares, :inverse_name => :shareable, embed: true
    list :sharers_ids
    counter :shares_counter
  end

  public

  def shared?(user)
    sharers_ids.values.include?(user.id.to_s)
  end

end