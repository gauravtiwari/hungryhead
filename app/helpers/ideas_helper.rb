module IdeasHelper

	def investment_remaing(fund)
		(fund.to_f/10000).round(2)
	end

	def feedbacks_remaing(feedbacks)
		(feedbacks.to_f/100).round(2)
	end
end
