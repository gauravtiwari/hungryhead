if @feedback
	json.(@feedback, :id, :status, :idea_id, :created_at, :updated_at)
	json.user_id @feedback.user.id
  json.body markdownify(@feedback.body)
	json.user_name @feedback.user.name
  json.badge_name @feedback.badge
	json.user_path profile_path(@feedback.user)
	json.created_at @feedback.created_at
	json.user_avatar @feedback.user.get_avatar
  json.user_badge @feedback.user.name_badge
  json.feedbacks_count @feedback.fetch_idea.feedbackers_counter.value

  json.meta do
    json.user_name your_name(current_user, false)
    json.idea_name @feedback.fetch_idea.name
    json.idea_path idea_path(@feedback.fetch_idea)
    json.can_feedback !@feedback.fetch_idea.feedbacked?(current_user)
    json.is_owner @feedback.fetch_idea.is_owner?(current_user)
    json.user_avatar current_user.get_avatar
  end
end
