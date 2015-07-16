json.current_user_id current_user.uid

json.mailbox @box
json.mailbox_size do
	json.inbox_count @mailbox.inbox.length
	json.sentbox_count @mailbox.sentbox.length
	json.trash_count @mailbox.trash.length
end

json.conversations @conversations.includes(:messages).each do |conversation|
	json.(conversation, :id, :subject, :created_at)
	json.uuid SecureRandom.hex(6)
	json.messages_count conversation.count_messages
	json.participants conversation.participants.select{ |p| p != current_user }.each do |participant|
		json.sender_avatar participant.get_avatar
		json.sender_name_badge participant.name_badge
		json.sender_path profile_path(participant)
	end
	if conversation.last_message
		json.last_message_body markdownify(conversation.last_message.body)
		json.last_message_created_at conversation.last_message.created_at
	else
		json.last_message_body 'No messages'
		json.last_message_created_at conversation.created_at
	end
	json.is_trashed conversation.is_trashed?(current_user)
	json.is_unread conversation.is_unread?(current_user)
	json.conversation_path conversation_path(conversation, box: @box)
	json.mark_read_path mark_as_read_conversation_path(conversation)
	json.restore_path restore_conversation_path(conversation)
end