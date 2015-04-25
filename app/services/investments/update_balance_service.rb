class UpdateBalanceService
	def initialize(investment)
		@investment = investment
		@user = investment.user
		@idea = investment.idea
	end

	def invest
		@user.update_attributes(:fund => {"balance" => @user.balance - @investment.amount})
		@investment.idea.update_attributes(:fund => {"balance" => @investment.idea.balance + @investment.amount})
		@investment.idea.investors.push(@user.id)
		@investment.idea.save
		@investment
	end
end