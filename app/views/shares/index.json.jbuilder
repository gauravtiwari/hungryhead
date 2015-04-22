json.payload do

  json.listings @sharers.each do |i|
    json.name your_name(i.user, false)
    json.avatar i.user.avatar.url(:avatar)
    json.uuid SecureRandom.hex(6)
    json.path profile_path(i.user)
    json.locations i.user.location_list.each do |tag|
       json.tag tag
       json.url profile_people_path(tag.parameterize)
    end
    json.about_me i.user.mini_bio
    json.is_following current_user.follows?(i.user)
    json.user_name_badge i.user.first_name.first + i.user.last_name.first
    json.followed followed?(i.user)
    json.not_current_user i.user != current_user
  end

  json.meta do
    json.current_page @sharers.current_page
    json.next_page @sharers.next_page
    json.prev_page @sharers.previous_page
    json.per_page @sharers.per_page
    json.total_pages @sharers.total_pages
    json.count @shareable.cached_votes_total
    json.label "People who shared this #{@shareable.class.to_s.downcase}"
  end

end