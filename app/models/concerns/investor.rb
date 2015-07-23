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
    investments.where("amount >= ? AND amount <= ?", 200, 500).length >= 60
  end

  def vc?
    investments.where("amount >= ? AND amount <= ?", 500, 900).length >= 150
  end

end