module Impressioner

  extend ActiveSupport::Concern
  included do
    has_many :impressions, dependent: :destroy
    cache_has_many :impressions, embed: true
  end
end