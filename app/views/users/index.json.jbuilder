json.payload do
  json.listings @users.each do |user|
    json.cache! [ user], expires_in: 2.hours do
        json.name user.name
        json.avatar user.avatar.url(:avatar)
        json.uuid SecureRandom.hex(10)
        json.role user.role
        json.path profile_path(user)
        json.locations user.location_list.each do |tag|
            json.tag tag
            json.url tag_people_path(tag.parameterize)
        end
        json.about_me user.mini_bio
        json.user_name_badge user.user_name_badge
        json.is_following user.followed_by?(current_user)
        json.followed followed?(user)
        json.not_current_user user != current_user
    end
  end

  json.meta do
    json.current_page @users.current_page
    json.next_page @users.next_page
    json.prev_page @users.previous_page
    json.per_page @users.per_page
    json.total_pages @users.total_pages
    json.count @users.size
    json.label "People you may know"
  end

end