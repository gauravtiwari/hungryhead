json.rate do
  json.record activity.trackable_id
  json.voted  activity.trackable.accepted?
  json.vote_url  rate_idea_feedback_path(activity.recipient.slug, activity.trackable_id)
  json.user_name  activity.user.name.capitalize
  json.badge_class  activity.trackable.badges.last.custom_fields[:class] if activity.trackable.badges.length > 0
  json.badge_name activity.trackable.badges.last.custom_fields[:name].downcase if activity.trackable.badges.length > 0
  json.id  activity.trackable_id
  json.badge_bg activity.trackable.badges.last.custom_fields[:bg] if activity.trackable.badges.length > 0
  json.points activity.user.points(category: "Feedback_#{activity.trackable_id}")
  json.votes_count  activity.trackable.votes_counter.value
end