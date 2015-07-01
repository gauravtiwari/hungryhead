if @feedback
	json.(@feedback, :id, :status, :idea_id, :created_at, :updated_at)
	json.user_id @feedback.fetch_user.id
  json.body markdownify(@feedback.body)
	json.user_name @feedback.fetch_user.name
  json.badge_name @feedback.badge
	json.user_path profile_path(@feedback.fetch_user)
	json.created_at @feedback.created_at
	json.user_avatar @feedback.fetch_user.avatar.url(:mini)
  json.feedbacks_count @feedback.fetch_idea.feedbackers_counter.value

  json.meta do
    json.user_name your_name(current_user, false)
    json.idea_name @feedback.fetch_idea.name
    json.idea_path idea_path(@feedback.fetch_idea)
    json.can_feedback !@feedback.fetch_idea.feedbacked?(current_user)
    json.is_owner @feedback.fetch_idea.is_owner?(current_user)
    json.user_avatar current_user.avatar.url(:mini)
  end
end
