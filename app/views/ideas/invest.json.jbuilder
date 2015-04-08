json.idea do
  json.form action: idea_investments_path(@idea), investable_id: @idea.id, investor_id: current_user.id, csrf_param: request_forgery_protection_token, csrf_token: form_authenticity_token, idea_id: @idea.id
  json.name @idea.name
  json.can_invest @idea.can_invest?(current_user)
  json.idea_fund @idea.balance
  json.user_fund current_user.balance
  json.has_invested @idea.has_invested?(current_user)
end
