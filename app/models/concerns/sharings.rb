module Sharings
  extend ActiveSupport::Concern

  included do
    has_many :shares, as: :owner, dependent: :destroy
    cache_has_many :shares, inverse_name: :owner, embed: true
  end

end