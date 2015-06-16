json.extract! @idea_message, :id, :body, :status, :created_at
json.user_name @idea_message.user.name
json.user_avatar @idea_message.user.avatar.url(:avatar)
json.user_id @idea_message.user.uid
json.user_path profile_path(@idea_message.user)
json.uuid SecureRandom.hex(10)
