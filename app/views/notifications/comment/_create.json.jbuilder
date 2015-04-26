json.activity do
  json.actor activity.user.name
  json.recipient activity.recipient_type == "Comment" ? activity.recipient.user.name : activity.recipient.name
  json.recipient_type activity.trackable_type == "Mention" ? activity.trackable.mentioner.class.to_s.downcase : activity.trackable_type.downcase
  json.id activity.id
  json.created_at activity.created_at
  json.url profile_path(activity.user)
  json.verb activity.verb
end