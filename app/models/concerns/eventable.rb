module Eventable

  extend ActiveSupport::Concern

  included do
    has_many :events, as: :owner, dependent: :destroy
    cache_has_many :events, inverse_name: :owner, embed: true
  end

end