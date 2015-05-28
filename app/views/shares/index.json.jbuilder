json.payload do

  json.listings @sharers.each do |sharer|
    json.name your_name(sharer, false)
    json.avatar sharer.avatar.url(:avatar)
    json.uuid sharer.uid
    json.path profile_path(sharer)
    json.locations sharer.location_list.each do |tag|
       json.tag tag
       json.url tag_people_path(tag.parameterize)
    end
    json.about_me sharer.mini_bio
    json.is_following sharer.followers_ids.members.include?(current_user.id.to_s)
    json.user_name_badge sharer.first_name.first + sharer.last_name.first
    json.followed followed?(sharer)
    json.not_current_user sharer != current_user
  end

  json.meta do
    json.current_page @sharers.current_page
    json.next_page @sharers.next_page
    json.prev_page @sharers.previous_page
    json.per_page @sharers.per_page
    json.total_pages @sharers.total_pages
    json.count @shareable.votes_counter.value
    json.label "People who shared this #{@shareable.class.to_s.downcase}"
  end

end