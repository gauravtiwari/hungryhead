class UpdateInvestmentBalanceJob < ActiveJob::Base
  def perform(investment_id)
    ActiveRecord::Base.connection_pool.with_connection do
      @investment = Investment.find(investment_id)
      Idea.transaction do
        @idea = @idea.lock(true).find(@investment.idea_id)
        @idea.update_attributes!(:fund => {"balance" => @idea.balance + @investment.amount})
      end
      User.transaction do
        @user = User.lock(true).find(@investment.user_id)
        @user.update_attributes!(:fund => {"balance" => @user.balance - @investment.amount})
      end
    end
  end
end