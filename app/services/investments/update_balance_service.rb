class UpdateBalanceService
	def initialize(investment)
		@investment = investment
	end

	def invest
		@investment.user.update_attributes!(:fund => {"balance" => @investment.user.balance - @investment.amount})
		@investment.idea.update_attributes!(:fund => {"balance" => @investment.idea.balance + @investment.amount})
		@investment
	end
end