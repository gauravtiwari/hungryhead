module Investable

  extend ActiveSupport::Concern

  included do
    has_many :investments, dependent: :destroy
  end

  def can_invest?(user)
    user.balance > 10 && !invested?(user)
  end

  def invested?(user)
    investors_ids.values.include?(user.id.to_s)
  end

  def find_investors
    Idea.where(id: investors_ids.values)
  end

end