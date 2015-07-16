json.payload do

  json.listings @followings.each do |followed|
    json.cache! [ followed ], expires_in: 2.hours do
        json.name followed.name
        json.avatar followed.get_avatar
        json.uuid SecureRandom.hex(10)
        json.role followed.role
        json.path profile_path(followed)
        json.locations followed.location_list.each do |tag|
            json.tag tag
            json.url tag_people_path(tag.parameterize)
        end
        json.about_me followed.mini_bio
        json.user_name_badge followed.name_badge
        json.is_following followed.followed_by?(current_user)
        json.followed followed?(followed)
        json.not_current_user followed != current_user
    end
  end

  json.meta do
    json.cache! [ "followings", @followings.size, @followings.next_page ], expires_in: 2.hours do
        json.current_page @followings.current_page
        json.next_page @followings.next_page
        json.prev_page @followings.previous_page
        json.per_page @followings.per_page
        json.total_pages @followings.total_pages
        json.count @followable.followings_counter.value
        json.label "People who are followed by #{@followable.name}"
    end
  end

end