module Voter

  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :voter, class_name: 'Vote', :dependent => :destroy
  end

end