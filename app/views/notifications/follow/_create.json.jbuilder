json.id notification.id
json.verb notification.verb
json.text "followed #{current_user == notification.recipient ? 'you' : notification.recipient.name}" if notification.recipient_type == "User"
json.text "followed #{notification.recipient.name}" if notification.recipient_type == "Idea" || notification.recipient_type == "School"
json.actor notification.user.name
json.actor_name_badge notification.user.user_name_badge
json.actor_avatar notification.user.avatar.url(:avatar) if notification.user.avatar.present?
json.url profile_path(notification.user)
json.created_at notification.created_at
