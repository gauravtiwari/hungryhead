json.user do
	json.avatar do
		json.url @user.avatar.url(:avatar) if @user.avatar
	end
	json.cover do
		json.url @user.cover.url(:cover) if @user.cover
		json.top @user.cover_position if @user.cover
		json.left @user.cover_left if @user.cover
	end

	json.profile do
		json.name @user.name
		json.username @user.username
		json.email @user.email
		json.school_id @user.school.id if @user.school
		json.school @user.school.name if @user.school
		json.school_url profile_path(@user.school) if @user.school
		json.mini_bio @user.mini_bio
		json.website_url @user.website_url
		json.facebook_url @user.facebook_url
		json.linkedin_url @user.linkedin_url
		json.twitter_url @user.twitter_url
		json.location @user.location_list.first
		json.location_url profile_people_path(@user.location_list.first.parameterize) if @user.location_list.first 
	end

	json.is_owner @user == current_user
	json.form delete_action: profile_delete_cover_path(@user), action: user_path(@user), method: "PUT", csrf_param: request_forgery_protection_token, csrf_token: form_authenticity_token
	json.name @user.name

	json.about_me do
		json.sidebar do
			json.skills @user.skill_list.each do |tag|
				json.tag tag
				json.url profile_path(tag.parameterize)
			end
			json.services @user.service_list.each do |tag|
				json.tag tag
				json.url profile_path(tag.parameterize)
			end
			json.markets @user.market_list.each do |tag|
				json.tag tag
				json.url profile_people_path(tag.parameterize)
			end

			json.technologies @user.technology_list.each do |tag|
				json.tag tag
				json.url profile_path(tag.parameterize)
			end
		end

		json.content @user.about_me
		json.form action: user_path(@user), method: "PUT", csrf_param: request_forgery_protection_token, csrf_token: form_authenticity_token
	end
end
