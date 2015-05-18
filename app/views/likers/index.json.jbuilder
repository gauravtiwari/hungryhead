json.payload do

  json.listings @likers.each do |liker|
    json.name your_name(liker, false)
    json.avatar liker.avatar.url(:avatar)
    json.uuid SecureRandom.hex(10)
    json.path profile_path(liker)
    json.locations liker.location_list.each do |tag|
        json.tag tag
        json.url profile_people_path(tag.parameterize)
    end
    json.about_me liker.mini_bio
    json.is_following liker.followers_ids.members.include?(current_user.id.to_s)
    json.user_name_badge liker.user_name_badge
    json.followed followed?(liker)
    json.not_current_user liker != current_user
  end

  json.meta do
    json.current_page @likers.current_page
    json.next_page @likers.next_page
    json.prev_page @likers.previous_page
    json.per_page @likers.per_page
    json.total_pages @likers.total_pages
    json.count @votable.cached_votes_total
    json.label "People who liked this #{@votable.class.to_s.downcase}"
  end

end