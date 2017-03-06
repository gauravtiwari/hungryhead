module Feedbacker
  extend ActiveSupport::Concern

  included do
    has_many :feedbacks, dependent: :destroy
  end

  def feedbacked?(idea)
    idea.feedbackers_ids.values.include?(id.to_s)
  end

  def irrelevant_feedbacks_counter
    feedbacks.where(badge: 'irrelevant').size
  end

  def helpful_feedbacks_counter
    feedbacks.where(badge: 'helpful').size
  end

  def not_helpful_feedbacks_counter
    feedbacks.where(badge: 'unhelpful').size
  end
end
