json.school do
	json.school_logo do
		json.url @school.logo.url(:avatar)  if @school.logo
	end
	json.cover do
		json.url @school.cover.url(:cover)  if @school.cover
		json.position @school.cover_position
	end

	json.is_owner true if current_user

	json.form action: school_path(@school), method: "PUT", csrf_param: request_forgery_protection_token, csrf_token: form_authenticity_token
end
