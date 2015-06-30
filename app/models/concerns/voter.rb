module Voter

  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :voter, :dependent => :destroy
    cache_has_many :votes, inverse_name: :voter,  embed: true
  end

end