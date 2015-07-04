module Voter

  extend ActiveSupport::Concern

  included do
    has_many :votes, class_name: 'Vote', foreign_key: 'voter_id', :dependent => :destroy
  end

end