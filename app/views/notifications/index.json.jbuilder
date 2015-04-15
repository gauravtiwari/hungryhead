json.notifications @notifications.each do |notification|
	json.(notification, :id, :subject, :created_at)
	json.uuid SecureRandom.hex(6)
	json.body notification.body
	json.is_read notification.is_read?(@user)
	json.sender_name notification.notified_object.name
	json.sender_avatar notification.notified_object.avatar.url(:avatar)
end

if @notifications.length > 0
	json.meta do
		json.current_page @notifications.current_page
		json.next_page @notifications.next_page
		json.prev_page @notifications.previous_page
		json.total_pages @notifications.total_pages
	end 
end