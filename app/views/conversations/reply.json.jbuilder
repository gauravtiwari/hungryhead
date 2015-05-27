json.sender_avatar @reply.message.sender.avatar.url(:avatar)
json.body markdownify(@reply.message.body)
json.uuid SecureRandom.hex(5)
json.mailbox_type  @reply.mailbox_type.titlecase
json.conversation_id @reply.message.conversation_id
json.sender_name @reply.message.sender.name
json.created_at @reply.message.created_at
json.sender_path profile_path(@reply.message.sender)