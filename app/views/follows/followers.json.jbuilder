json.payload do

  json.listings @followers.each do |follower|
    json.name follower.name
    json.avatar follower.avatar.url(:avatar)
    json.uuid SecureRandom.hex(10)
    json.role follower.role
    json.path profile_path(follower)
    json.locations follower.location_list.each do |tag|
        json.tag tag
        json.url tag_people_path(tag.parameterize)
    end
    json.about_me follower.mini_bio
    json.user_name_badge follower.user_name_badge
    json.is_following follower.followed_by?(current_user)
    json.followed followed?(follower)
    json.not_current_user follower != current_user
  end

  json.meta do
    json.current_page @followers.current_page
    json.next_page @followers.next_page
    json.prev_page @followers.previous_page
    json.per_page @followers.per_page
    json.total_pages @followers.total_pages
    json.count @user.followers_counter.value
    json.label "People who followed #{@user.name}"
  end

end