json.organization do
	json.logo do
		json.url @organization.logo ? @organization.logo.url(:avatar) : "http://placehold.it/110x110/f2f2f2/000&text=#{@organization.short_name}"
	end
	json.cover do
		json.url @organization.cover.url(:cover)  if @organization.cover
		json.position @organization.cover_position
	end

	json.is_owner true if current_user

	json.form action: organization_path(@organization), method: "PUT", csrf_param: request_forgery_protection_token, csrf_token: form_authenticity_token
end
