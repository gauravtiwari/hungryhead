json.school do
	json.cache! ["school_json_response", @school, current_user], expires_in: 2.hours do
		json.logo do
			json.url @school.get_avatar  if @school.logo
		end

		json.cover do
			json.url @school.cover.url(:large)  if @school.cover
			json.top @school.cover_position if @school.cover
	    json.left @school.cover_left if @school.cover
	    json.has_cover @school.cover.present?
		end

		json.name @school.name
		json.badge @school.name_badge
		json.email @school.email
		json.phone @school.phone

		json.location_name @school.location_list.first

		json.locations do
			if @school.cached_location_list.present?
				json.array! @school.location_list.each do |location|
					json.tag location
					json.url tag_people_path(location.parameterize)
				end
			end
		end

		json.description @school.description

		json.website_url url_with_protocol(@school.website_url)
		json.twitter_url url_with_protocol(@school.twitter_url)
		json.facebook_url url_with_protocol(@school.facebook_url)
		json.is_owner current_user == @school.user
		json.form action: school_path(@school), method: "PUT"
	end
end
