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

  def angel_investor?
    investments.where("amount < ? AND amount > ?", 100, 300).count == 60
  end

  def vc?
    investments.where("amount < ? AND amount > ?", 900, 500).count == 150
  end

end