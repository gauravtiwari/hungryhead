json.id notification.id
json.verb notification.verb
json.text "invested in #{notification.recipient.name}"
json.actor notification.user.name
json.actor_name_badge notification.user.user_name_badge
json.actor_avatar notification.user.avatar.url(:avatar) if notification.user.avatar.present?
json.recipient notification.recipient.name
json.url profile_path(notification.user)
json.created_at notification.created_at
