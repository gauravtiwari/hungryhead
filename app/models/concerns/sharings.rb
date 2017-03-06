module Sharings
  extend ActiveSupport::Concern

  included do
    has_many :shares, as: :user, dependent: :destroy
  end
end
