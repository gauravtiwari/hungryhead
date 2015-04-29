json.mention do
	json.id notification.id
	json.verb notification.verb
  json.text "commented on #{current_user == recipient.user ? 'your' : recipient.user.name} #{recipient_type.to_s.downcase}" if notification.recipient_type != "Idea"
  json.text "commented on #{current_user == recipient.user ? 'your' : recipient.student.name} #{recipient_type.to_s.downcase}" if notification.recipient_type == "Idea"
	json.actor notification.user.name
	json.actor_name_badge notification.user.user_name_badge
	json.actor_avatar notification.user.avatar.url(:avatar) if notification.user.avatar.present?
	json.recipient notification.recipient.name
	json.url profile_path(notification.user)
	json.created_at notification.created_at
end