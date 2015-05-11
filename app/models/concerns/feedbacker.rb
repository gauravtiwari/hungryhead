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

  def first_feedback?
    feedbacks_counter.value == 1
  end

  def feedback_10?
    feedbacks_counter.value == 10
  end

end