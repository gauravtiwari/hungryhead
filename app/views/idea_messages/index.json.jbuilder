if @idea_messages
	json.idea_messages @idea_messages.each do |idea_message|
		json.(idea_message, :id, :body, :status, :created_at)
		json.user_name idea_message.user.name
		json.uuid SecureRandom.hex(5)
		json.user_id idea_message.user.id
		json.user_avatar idea_message.user.avatar.url(:avatar)
		json.user_path user_path(idea_message.user)
	end
	json.meta do
	    json.current_page @idea_messages.current_page
	    json.next_page @idea_messages.next_page
	    json.prev_page @idea_messages.previous_page
	    json.per_page @idea_messages.per_page
	    json.total_pages @idea_messages.total_pages
	    json.idea_messages_count @idea.idea_messages_count
    end
end