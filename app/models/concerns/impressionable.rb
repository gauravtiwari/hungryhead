module Impressionable

  extend ActiveSupport::Concern

  included do
    has_many :impressions, as: :impressionable, dependent: :destroy
    cache_has_many :impressions, inverse_name: :impressionable, embed: true
  end

end