if @idea_messages
	json.idea_messages @idea_messages.each do |idea_message|
		json.cache! idea_message, expires_in: 2.hours do
			json.(idea_message, :id, :status, :created_at)
			json.user_name idea_message.user.name
			json.body linkify idea_message.body
			json.user_badge idea_message.user.name_badge
			json.uuid SecureRandom.hex(10)
			json.user_id idea_message.user.uid
			json.user_avatar idea_message.user.get_avatar
			json.user_path profile_path(idea_message.user)
		end
	end

	json.meta do
		json.cache! ["idea_messages", @idea.idea_messages_counter.value], expires_in: 2.hours do
	    json.current_page @idea_messages.current_page
	    json.next_page @idea_messages.next_page
	    json.prev_page @idea_messages.previous_page
	    json.slug @idea.slug
	  end
  end
end