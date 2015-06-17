module Eventable

  extend ActiveSupport::Concern

  included do
    has_many :events, dependent: :destroy
  end

end