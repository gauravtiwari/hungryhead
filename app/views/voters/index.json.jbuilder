json.payload do

  json.listings @voters.each do |voter|
    json.name your_name(voter, false)
    json.avatar voter.avatar.url(:avatar)
    json.uuid voter.uid
    json.path profile_path(voter)
    json.locations voter.location_list.each do |tag|
       json.tag tag
       json.url tag_people_path(tag.parameterize)
    end
    json.about_me voter.mini_bio
    json.is_following voter.followed_by?(current_user)
    json.user_name_badge voter.first_name.first + voter.last_name.first
    json.followed followed?(voter)
    json.not_current_user voter != current_user
  end

  json.meta do
    json.current_page @voters.current_page
    json.next_page @voters.next_page
    json.count @votable.votes_counter.value
    json.label "People who voted on this #{@votable.class.to_s.downcase}"
  end

end