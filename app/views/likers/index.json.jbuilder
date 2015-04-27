json.payload do

  json.listings @likers.each do |i|
    json.name your_name(i.voter, false)
    json.avatar i.voter.avatar.url(:avatar)
    json.uuid SecureRandom.hex(6)
    json.path profile_path(i.voter)
    json.locations i.voter.location_list.each do |tag|
        json.tag tag
        json.url profile_people_path(tag.parameterize)
    end
    json.about_me i.voter.mini_bio
    json.is_following current_user.follows?(i.voter)
    json.user_name_badge i.voter.first_name.first + i.voter.last_name.first
    json.followed followed?(i.voter)
    json.not_current_user i.voter != current_user
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