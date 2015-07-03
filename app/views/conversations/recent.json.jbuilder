json.conversations_count @mailbox.inbox.order(created_at: :desc).length
json.conversations @conversations.includes(:messages).each do |conversation|
	json.(conversation, :id, :subject, :created_at)
	json.uuid SecureRandom.hex(6)
	json.messages_count conversation.messages.length
	json.sender_avatar conversation.last_message.sender.avatar.url(:avatar)
	json.sender_name_badge conversation.last_message.sender.user_name_badge
	json.last_message_body truncate(markdownify(conversation.last_message.body), length: 50, escape: false)
	json.last_message_created_at conversation.last_message.created_at
	json.is_unread conversation.is_unread?(current_user)
	json.conversation_path conversation_path(conversation, box: @box)
end

if @conversations.size > 0
	json.meta do
		json.current_page @conversations.current_page
		json.next_page @conversations.next_page
		json.prev_page @conversations.previous_page
		json.total_pages @conversations.total_pages
	end
end