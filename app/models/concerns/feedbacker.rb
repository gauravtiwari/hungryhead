module Feedbacker

  extend ActiveSupport::Concern

  included do
    has_many :feedbacks, dependent: :destroy
  end

  def feedbacked?(idea)
    idea.feedbackers_ids.values.include?(id.to_s)
  end

  def irrelevant_feedbacks_counter
    fetch_feedbacks.select{|f| f.badge == "irrelevant"}.count
  end

  def helpful_feedbacks_counter
    fetch_feedbacks.select{|f| f.badge == "helpful"}.count
  end

  def not_helpful_feedbacks_counter
    fetch_feedbacks.select{|f| f.badge == "unhelpful"}.count
  end

end