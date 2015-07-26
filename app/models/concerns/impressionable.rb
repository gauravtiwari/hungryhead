module Impressionable

  extend ActiveSupport::Concern

  included do
    has_many :impressions, as: :impressionable, dependent: :destroy
  end

end