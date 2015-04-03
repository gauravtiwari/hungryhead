if @notes
	json.notes @notes.each do |note|
		json.(note, :id, :status, :parameters, :created_at)
		json.user_name your_name(note.user, false)
		json.uuid SecureRandom.hex(5)
		json.user_id note.user.id
		json.user_avatar note.user.avatar.url(:avatar)
		json.user_path user_path(note.user)
	end
	json.meta do
	    json.current_page @notes.current_page
	    json.next_page @notes.next_page
	    json.prev_page @notes.previous_page
	    json.per_page @notes.per_page
	    json.total_pages @notes.total_pages
	    json.idea_messages_count @idea.notes_count
    end
end