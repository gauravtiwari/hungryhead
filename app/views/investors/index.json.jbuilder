json.payload do

  json.listings @investors.each do |i|
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
    json.current_page @investors.current_page
    json.next_page @investors.next_page
    json.prev_page @investors.previous_page
    json.per_page @investors.per_page
    json.total_pages @investors.total_pages
    json.count @idea.investors.length
    json.label "People who invested in #{@idea.name}"
  end

end