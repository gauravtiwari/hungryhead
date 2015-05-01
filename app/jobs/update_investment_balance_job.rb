class UpdateInvestmentBalanceJob < ActiveJob::Base
  def perform(investment_id)
    ActiveRecord::Base.connection_pool.with_connection do
      @investment = Investment.find(investment_id)
      UpdateBalanceService.new(@investment).invest
    end
  end
end