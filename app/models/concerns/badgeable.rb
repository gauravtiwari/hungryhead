module Badgeable

  extend ActiveSupport::Concern

  included do
    has_many :badges, as: :badgeable, dependent: :destroy
  end

  def add_badge! args, options = {}
    badges.new(args)
  end

end