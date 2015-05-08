module Feedbackable

  extend ActiveSupport::Concern

  included do
    has_many :feedbacks, dependent: :destroy
    cache_has_many :feedbacks, :embed => true
    list :feedbackers_ids
    counter :feedbackers_counter
  end

  def feedbacked?(user)
    feedbackers_ids.values.include?(user.id.to_s)
  end

  def find_feedbackers
    User.where(id: feedbackers_ids.values)
  end

end