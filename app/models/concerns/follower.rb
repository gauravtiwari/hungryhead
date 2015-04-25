module Follower
  extend ActiveSupport::Concern

  included do
    has_many :follows, as: :follower, :dependent => :destroy
  end
end