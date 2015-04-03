json.notifications_count @user.notifications.length
json.notifications @notifications.each do |notification|
	json.(notification, :id, :created_at)
	json.uuid SecureRandom.hex(6)
	json.body notification.msg
	json.is_read notification.read
	json.sender_name notification.sender.name
	json.sender_avatar notification.sender.avatar.url(:avatar)
end

if @notifications.length > 0
	json.meta do
		json.current_page @notifications.current_page
		json.next_page @notifications.next_page
		json.prev_page @notifications.previous_page
		json.total_pages @notifications.total_pages
	end 
end