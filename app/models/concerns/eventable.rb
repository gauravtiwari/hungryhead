module Eventable

  included do
    has_many :events, dependent: :destroy
  end

end