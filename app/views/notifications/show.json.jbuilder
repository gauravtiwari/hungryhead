json.(notification, :id, :created_at)
json.uuid SecureRandom.hex(6)
json.body notification.msg
json.is_read notification.read
json.sender_name notification.sender.name
json.sender_avatar notification.sender.avatar.url(:avatar)

