module Mentioner
  extend ActiveSupport::Concern

  included do
    has_many :mentions, as: :mentioner, :dependent => :destroy
  end
end