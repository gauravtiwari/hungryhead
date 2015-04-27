json.extract! @idea_message, :id, :body, :status, :created_at
json.user_name @idea_message.student.name
json.user_avatar @idea_message.student.avatar.url(:avatar)
json.user_id @idea_message.student.id
json.user_path user_path(@idea_message.student)
json.uuid SecureRandom.hex(5)
