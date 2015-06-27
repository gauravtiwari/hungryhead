json.user do
	json.avatar do
		json.url @user.avatar.url(:avatar) if @user.avatar
	end

	json.cover do
	  json.url  @user.cover.present? ? @user.cover.url(:cover) : "#{root_url}assets/building-ecosystem.png"
	  json.top @user.cover_position if @user.cover
	  json.left @user.cover_left if @user.cover
	  json.has_cover @user.cover.present?
	end

	json.about_me do
	  json.content @user.about_me
	  json.form action: user_path(@user), method: "PUT"
	end

	json.profile do
		json.name @user.name
		json.username @user.username
		json.email @user.email
		json.school_id @user.school.id if @user.school
		json.school_name @user.school.name if @user.school
		json.school_url profile_path(@user.school) if @user.school
		json.mini_bio @user.mini_bio
		json.website_url url_with_protocol(@user.website_url)
		json.facebook_url url_with_protocol(@user.facebook_url)
		json.linkedin_url url_with_protocol(@user.linkedin_url)
		json.twitter_url url_with_protocol(@user.twitter_url)
		json.location_name @user.location_list.first if @user.location_list

		json.locations do
			if @user.cached_location_list.present?
				json.array! @user.location_list.each do |tag|
					json.tag tag
					json.url tag_people_path(tag: tag.parameterize)
				end
			end
		end

		json.skills do
			if @user.cached_skill_list.present?
				json.array!  @user.skill_list.each do |tag|
					json.tag tag
					json.url tag_people_path(tag: tag.parameterize)
				end
			end
		end

		json.subjects do
			if @user.cached_subject_list.present?
				json.array! @user.subject_list.each do |tag|
					json.tag tag
					json.url tag_people_path(tag: tag.parameterize)
				end
			end
		end

		json.markets do
			if @user.cached_market_list.present?
				 json.array! @user.market_list.each do |tag|
					json.tag tag
					json.url tag_people_path(tag: tag.parameterize)
				end
			end
		end

		json.hobbies do
			if @user.cached_hobby_list.present?
				json.array! @user.hobby_list.each do |tag|
					json.tag tag
					json.url tag_people_path(tag: tag.parameterize)
				end
			end
		end

	end

	json.id @user.uid
	json.is_owner @user == current_user
	json.form delete_action: profile_delete_cover_path(@user), action: user_path(@user), method: "PUT"
	json.name @user.name
	json.badge @user.user_name_badge
end
