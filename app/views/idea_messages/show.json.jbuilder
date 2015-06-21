json.cache! @idea_message, expires_in: 2.hours do
  json.extract! @idea_message, :id, :body, :status, :created_at
  json.user_name @idea_message.user.name
  json.user_badge @idea_message.user.user_name_badge
  json.user_avatar @idea_message.user.avatar.url(:avatar)
  json.user_id @idea_message.user.uid
  json.user_path profile_path(@idea_message.user)
  json.uuid SecureRandom.hex(10)
end
