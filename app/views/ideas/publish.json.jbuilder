json.msg @msg
json.profile_complete @idea.profile_complete?
json.current_privacy @idea.privacy.capitalize
json.published @idea.published?
json.is_public @idea.everyone?
json.is_team @idea.team?
json.url publish_idea_path(@idea)