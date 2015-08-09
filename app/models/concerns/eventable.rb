module Eventable

  extend ActiveSupport::Concern

  included do
    has_many :events, as: :user, dependent: :destroy
  end

end