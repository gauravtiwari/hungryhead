module Sharings
  extend ActiveSupport::Concern

  included do
    has_many :shares, as: :owner, dependent: :destroy
  end

end