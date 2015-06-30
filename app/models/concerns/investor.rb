module Investor

  extend ActiveSupport::Concern

  included do
    has_many :investments, dependent: :destroy
    cache_has_many :investments, embed: true
  end

  def can_invest?(idea)
    balance > 10 && !invested?(idea)
  end

  def invested?(idea)
    idea.investors_ids.values.include?(id.to_s)
  end

  def angel_investor?
    fetch_investments.select{|i| i.amount > 200 && i.amount < 500}.length >= 60
  end

  def vc?
    fetch_investments.select{|i| i.amount < 900 && i.amount > 500}.length >= 150
  end

end