json.idea do
  json.form action: idea_investments_path(@idea), investable_id: @idea.id, investor_id: current_user.id, csrf_param: request_forgery_protection_token, csrf_token: form_authenticity_token, idea_id: @idea.id
  json.name @idea.name
  json.can_invest @idea.can_invest?(current_user)
  json.idea_fund @idea.balance
  json.user_avatar current_user.avatar.url(:avatar)
  json.amount @investment.amount
  json.investments_count @investment.idea.investors_counter.value
  json.raised @investment.idea.balance
  json.has_invested !@idea.invested?(current_user)
end
