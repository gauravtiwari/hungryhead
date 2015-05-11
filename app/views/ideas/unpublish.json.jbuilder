  json.is_public false
  json.msg "We couldn't publish your idea profile as it's incomplete"
  json.profile_complete @idea.profile_complete?
  json.published @idea.published?
  json.url publish_idea_path(@idea)