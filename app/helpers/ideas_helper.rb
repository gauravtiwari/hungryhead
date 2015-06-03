module IdeasHelper

	def invested?(idea)
      idea = {
        form: {
          action: idea_investments_path(@idea),
          idea_id: @idea.id
        },
        name: @idea.name,
        can_invest: @idea.can_invest?(current_user),
        idea_fund: @idea.balance,
        user_fund: current_user.balance,
        has_invested: !@idea.invested?(current_user)
      }
  end

end
