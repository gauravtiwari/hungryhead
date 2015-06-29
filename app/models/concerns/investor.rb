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

  def angel_investor?
    fetch_investments.where("amount < ? AND amount > ?", 100, 300).count == 60
  end

  def vc?
    fetch_investments.where("amount < ? AND amount > ?", 900, 500).count == 150
  end

end