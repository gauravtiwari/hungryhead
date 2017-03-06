module Impressioner
  extend ActiveSupport::Concern
  included do
    has_many :impressions, dependent: :destroy
  end
end
