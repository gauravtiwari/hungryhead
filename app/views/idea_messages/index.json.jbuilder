if @idea_messages
	json.idea_messages @idea_messages.each do |idea_message|
		json.(idea_message, :id, :body, :status, :created_at)
		json.user_name idea_message.user.name
		json.uuid SecureRandom.hex(10)
		json.user_id idea_message.user.uid
		json.user_avatar idea_message.user.avatar.url(:avatar)
		json.user_path profile_path(idea_message.user)
	end
	json.meta do
	    json.current_page @idea_messages.current_page
	    json.next_page @idea_messages.next_page
	    json.prev_page @idea_messages.previous_page
    end
end