module Feedbackable
  extend ActiveSupport::Concern

  included do
    has_many :feedbacks, dependent: :destroy
  end

  def feedbacked?(user)
    feedbackers_ids.values.include?(user.id.to_s)
  end

  def find_feedbackers
    User.find(feedbackers_ids.values)
  end
end
