json.payload do

  json.listings @followers.each do |i|
    json.name i.name
    json.avatar i.avatar.url(:avatar)
    json.uuid SecureRandom.hex(6)
    json.role i.role
    json.path user_path(i)
    json.locations i.location_list.each do |tag|
        json.tag tag
        json.url profile_people_path(tag.parameterize)
    end
    json.about_me i.about_me
    json.is_following current_user.follows?(i)
    json.followed followed?(i)
    json.not_current_user i != current_user
  end

  json.meta do
    json.current_page @followers.current_page
    json.next_page @followers.next_page
    json.prev_page @followers.previous_page
    json.per_page @followers.per_page
    json.total_pages @followers.total_pages
    json.count count_followers(@idea)
    json.label "People who followed #{@idea.name}"
  end

end