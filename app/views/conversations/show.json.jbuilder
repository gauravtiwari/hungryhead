json.mailbox @box.titlecase
json.conversation do
	json.(@conversation, :id)
	json.form uuid: SecureRandom.hex(7), reply_conversation_path: reply_conversation_path(@conversation), csrf_param: request_forgery_protection_token, csrf_token: form_authenticity_token
end
json.active_conversation do
	json.(@conversation, :id, :subject, :created_at)
	json.uuid SecureRandom.hex(7)
	json.is_trashed @conversation.is_trashed?(current_user)
	json.is_unread @conversation.is_unread?(current_user)
	json.participants @conversation.participants.select{ |p| p != current_user }.each do |participant|
		json.sender_avatar participant.avatar.url(:avatar)
		json.sender_name_badge participant.user_name_badge
		json.sender_path profile_path(participant)
	end
	json.conversation_path conversation_path(@conversation)
	json.mark_read_path mark_as_read_conversation_path(@conversation)
	json.restore_path restore_conversation_path(@conversation)
end

json.messages @receipts.includes(:message).each do |receipt|
	json.sender_avatar receipt.message.sender.avatar.url(:avatar)
	json.sender_name_badge receipt.message.sender.user_name_badge
	json.body markdownify(receipt.message.body)
	json.uuid SecureRandom.hex(5)
	json.conversation_id receipt.message.conversation_id
	json.mailbox_type  @conversation.is_trashed?(current_user) ? 'Trashed' : receipt.mailbox_type.titlecase
	json.sender_name receipt.message.sender.name
	json.created_at receipt.message.created_at
	json.sender_path profile_path(receipt.message.sender)
end
json.conversations @conversations.includes(:messages).each do |conversation|
	json.(conversation, :id, :subject, :created_at)
	json.uuid SecureRandom.hex(6)
	json.messages_count conversation.count_messages
	conversation.participants.select{ |p| p != current_user }.take(1).each do |participant|
		json.sender_avatar participant.avatar.url(:avatar)
		json.sender_name_badge participant.user_name_badge
		json.sender_path profile_path(participant)
	end
	json.last_message_body markdownify(conversation.last_message.body)
	json.last_message_created_at conversation.last_message.created_at
	json.is_trashed conversation.is_trashed?(current_user)
	json.is_unread conversation.is_unread?(current_user)
	json.conversation_path conversation_path(conversation, box: @box)
	json.mark_read_path mark_as_read_conversation_path(conversation)
	json.restore_path restore_conversation_path(conversation)
end