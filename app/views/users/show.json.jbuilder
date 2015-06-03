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
		json.theme @user.theme
		json.school_id @user.school.id if @user.school
		json.school_name @user.school.name if @user.school
		json.school_url profile_path(@user.school) if @user.school
		json.mini_bio @user.mini_bio
		json.verified @user.verified?
		json.type @user.type
		json.website_url @user.website_url
		json.facebook_url @user.facebook_url
		json.linkedin_url @user.linkedin_url
		json.twitter_url @user.twitter_url
		json.location_name @user.location_list.first if @user.location_list
		json.markets @user.market_list.each do |tag|
			json.tag tag
			json.url tag_people_path(tag: tag.parameterize)
		end
		json.hobbies @user.hobby_list.each do |tag|
			json.tag tag
			json.url tag_people_path(tag: tag.parameterize)
		end
		json.location_url tag_people_path(tag: @user.location_list.first.parameterize) if @user.location_list.first
	end

	json.id @user.uid
	json.is_owner @user == current_user
	json.form delete_action: profile_delete_cover_path(@user), action: user_path(@user), method: "PUT"
	json.name @user.name
	json.badge @user.first_name.first + @user.last_name.first

	json.about_me do
		json.content @user.about_me
		json.form action: user_path(@user), method: "PUT"
	end
end
