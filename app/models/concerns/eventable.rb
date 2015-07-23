module Eventable

  extend ActiveSupport::Concern

  included do
    has_many :events, as: :owner, dependent: :destroy
  end

end