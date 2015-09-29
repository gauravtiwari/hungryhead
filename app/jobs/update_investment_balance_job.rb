class UpdateInvestmentBalanceJob < ActiveJob::Base

  def perform(investment_id)
    # After user investment into idea, update user and idea balance
    ActiveRecord::Base.connection_pool.with_connection do
      @investment = Investment.find(investment_id)

      # Wrap into transaction block to avoid any race conditions
      Idea.transaction do
        @idea = @idea.lock(true).find(@investment.idea_id)
        @idea.update_attributes!(:fund => {"balance" => @idea.balance + @investment.amount})
      end

      # Wrap into transaction block to avoid any race conditions
      User.transaction do
        @user = User.lock(true).find(@investment.user_id)
        @user.update_attributes!(:fund => {"balance" => @user.balance - @investment.amount})
      end

    end
  end

end