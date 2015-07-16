json.idea do
  json.cache! [@idea, @investment], expires_in: 2.hours do
    json.form action: idea_investments_path(@idea), investable_id: @idea.id, investor_id: current_user.id, idea_id: @idea.id
    json.name @idea.name
    json.can_invest @idea.can_invest?(current_user)
    json.investable @idea.investable?
    json.idea_fund @idea.balance
    json.user_avatar current_user.get_avatar
    json.amount @investment.amount
    json.investments_count @investment.idea.investors_counter.value
    json.raised @investment.idea.balance
    json.has_invested !@idea.invested?(current_user)
  end
end
