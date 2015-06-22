json.school do
	json.cache! ["school_json_response", @school, current_user], expires_in: 2.hours do
		json.logo do
			json.url @school.logo.url(:avatar)  if @school.logo
		end

		json.cover do
			json.url @school.cover.url(:large)  if @school.cover
			json.top @school.cover_position if @school.cover
	    json.left @school.cover_left if @school.cover
	    json.has_cover @school.cover.present?
		end

		json.name @school.name
		json.badge @school.name_badge

		json.is_owner current_user == @school.fetch_admin

		json.form action: school_path(@school), method: "PUT"
	end
end
