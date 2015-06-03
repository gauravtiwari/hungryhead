json.school do

	json.logo do
		json.url @school.logo.url(:avatar)  if @school.logo
	end

	json.cover do
		json.url @school.cover.url(:large)  if @school.cover
		json.top @school.cover_position if @school.cover
    json.left @school.cover_left if @school.cover
	end

	json.name @school.name
	json.badge @school.name_badge

	json.is_owner true if current_user

	json.form action: school_path(@school), method: "PUT"
end
