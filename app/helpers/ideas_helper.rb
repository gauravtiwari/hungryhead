module IdeasHelper

	def invested?
      {
        form: {
          action: idea_investments_path(@idea),
          idea_id: @idea.id
        },
        score: Idea.leaderboard.score(@idea.id),
        name: @idea.name,
        can_invest: @idea.can_invest?(current_user),
        investable: @idea.investable?,
        idea_fund: @idea.balance,
        user_fund: current_user.balance,
        has_invested: !@idea.invested?(current_user)
      }
  end

  def cache_key_for_ideas
    count          = Idea.published.count
    max_updated_at = Idea.published.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "ideas/published-#{count}-#{max_updated_at}"
  end



end
