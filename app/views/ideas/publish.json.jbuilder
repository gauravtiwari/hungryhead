  json.is_public true
  json.msg "Your idea profile was successfully published to: #{@idea.privacy.capitalize}"
  json.profile_complete @idea.profile_complete?
  json.current_privacy @idea.privacy.capitalize
  json.published @idea.published?
  json.is_public @idea.everyone?
  json.is_team @idea.team?
  json.url unpublish_idea_path(@idea)
