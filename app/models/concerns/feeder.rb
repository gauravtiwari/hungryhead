module Feeder
  extend ActiveSupport::Concern
  included do
    has_many :activities, -> { where(published: true, is_notification: false) }, as: :user, dependent: :destroy
  end
end
