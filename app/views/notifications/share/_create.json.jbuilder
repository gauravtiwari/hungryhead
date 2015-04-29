json.share do
	json.id notification.id
	json.verb notification.verb
  json.text "shared #{recipient.user == current_user ? 'your' : recipient.name} #{recipient.class.to_s}" if notification.recipient_type != "Idea"
  json.text "shared #{recipient.student == current_user ? 'your' : recipient.name} #{recipient.class.to_s} #{recipient.name}" if notification.recipient_type == "Idea"
	json.actor notification.user.name
	json.actor_name_badge notification.user.user_name_badge
	json.actor_avatar notification.user.avatar.url(:avatar) if notification.user.avatar.present?
	json.url profile_path(notification.user)
	json.created_at notification.created_at
end