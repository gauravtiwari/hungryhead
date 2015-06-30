module Feedbacker

  extend ActiveSupport::Concern

  included do
    has_many :feedbacks, dependent: :destroy
    cache_has_many :feedbacks, embed: true
  end

  def feedbacked?(idea)
    idea.feedbackers_ids.values.include?(id.to_s)
  end

  def irrelevant_feedbacks_counter
    fetch_feedbacks.select{|f| f.badge == "irrelevant"}.length
  end

  def helpful_feedbacks_counter
    fetch_feedbacks.select{|f| f.badge == "helpful"}.length
  end

  def not_helpful_feedbacks_counter
    fetch_feedbacks.select{|f| f.badge == "unhelpful"}.length
  end

end