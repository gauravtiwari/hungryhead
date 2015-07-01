module Voter

  extend ActiveSupport::Concern

  included do
    has_many :votes, :dependent => :destroy
  end

end