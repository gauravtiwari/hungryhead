json.extract! @note, :id, :parameters, :status, :created_at
json.user_name your_name(@note.user, false)
json.user_avatar @note.user.avatar.url(:avatar)
json.user_id @note.user.id
json.user_path user_path(@note.user)
json.uuid SecureRandom.hex(5)
