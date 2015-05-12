module Investor

  extend ActiveSupport::Concern

  included do
    has_many :investments, dependent: :destroy
  end

  def can_invest?(idea)
    balance > 10 && !invested?(idea)
  end

  def invested?(idea)
    idea.investors_ids.values.include?(id.to_s)
  end

  def find_investments
    Investment.where(id: id)
  end

  def first_investment?
    investments_counter.value == 1
  end

  def investments_50?
    investments_counter.value == 50
  end

end