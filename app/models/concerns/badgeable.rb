module Badgeable

  extend ActiveSupport::Concern

  included do
    has_many :badges, as: :badgeable, dependent: :destroy
  end

end