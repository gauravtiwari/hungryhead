json.institution do
	json.institution_logo do
		json.url @institution.logo.url(:avatar)  if @institution.logo
	end
	json.cover do
		json.url @institution.cover.url(:cover)  if @institution.cover
		json.position @institution.cover_position
	end

	json.is_owner true if current_user

	json.form action: institution_path(@institution), method: "PUT", csrf_param: request_forgery_protection_token, csrf_token: form_authenticity_token
end
