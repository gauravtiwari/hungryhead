module Mentionable
  extend ActiveSupport::Concern

  included do
    has_many :mentions, as: :mentionable, :dependent => :destroy
    cache_has_many :mentions, inverse_name: :mentionable
  end

end