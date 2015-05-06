if @feedback
	json.(@feedback, :id, :status, :idea_id, :created_at, :updated_at)
	json.user_id @feedback.user.id
  json.body markdownify(@feedback.body)
	json.user_name @feedback.user.name
	json.user_path profile_path(@feedback.user)
	json.created_at @feedback.created_at
	json.user_avatar @feedback.user.avatar.url(:mini)

  if feedback.present?
    json.rate do
      json.record feedback.id
      json.voted  feedback.badged?
      json.vote_url  rate_idea_feedback_path(feedback.idea.slug, feedback.id)
      json.user_name  feedback.user.name.capitalize
      json.badge_class  feedback.badges.last.custom_fields[:class] if feedback.badges.length > 0
      json.badge_name feedback.badges.last.custom_fields[:name].downcase if feedback.badges.length > 0
      json.id  feedback.id
      json.badge_bg feedback.badges.last.custom_fields[:bg] if feedback.badges.length > 0
      json.points feedback.user.points(category: "Feedback_#{feedback.id}")
      json.votes_count  feedback.votes_counter.value
    end
  end

  json.meta do
    json.user_name your_name(current_user, false)
    json.idea_name @feedback.idea.name
    json.idea_path idea_path(@feedback.idea)
    json.can_feedback !@feedback.idea.feedbacked?(current_user)
    json.is_owner @feedback.idea.is_owner?(current_user)
    json.user_avatar current_user.avatar.url(:mini)
  end
end
