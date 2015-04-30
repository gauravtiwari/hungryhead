module Voter

  extend ActiveSupport::Concern
  included do
    has_many :votes, as: :voter, :dependent => :destroy
  end
end