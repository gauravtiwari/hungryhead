module Feedbacker

  extend ActiveSupport::Concern

  included do
    has_many :feedbacks, dependent: :destroy
  end

  def feedbacked?(idea)
    idea.feedbackers_ids.values.include?(id.to_s)
  end

  def find_feedbacks
    Feedback.where(id: id)
  end

  def irrelevant_feedbacks_counter
    feedbacks.where(badge: 3).count
  end

  def helpful_feedbacks_counter
    feedbacks.where(badge: 1).count
  end

  def not_helpful_feedbacks_counter
    feedbacks.where(badge: 2).count
  end

end