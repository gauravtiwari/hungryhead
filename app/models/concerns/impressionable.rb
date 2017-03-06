module Impressionable
  extend ActiveSupport::Concern

  included do
    has_many :impressions, as: :impressionable, dependent: :destroy
  end

  def viewed?(user)
    impressioners_ids.member?(user.id)
  end
end
