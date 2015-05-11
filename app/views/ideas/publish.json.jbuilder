  json.is_public true
  json.msg "Your idea profile was published successfully"
  json.profile_complete @idea.profile_complete?
  json.published @idea.published?
  json.url unpublish_idea_path(@idea)
