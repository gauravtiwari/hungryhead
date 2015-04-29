json.payload do

  json.listings @feedbackers.each do |i|
    json.name i.name
    json.avatar i.avatar.url(:avatar)
    json.uuid SecureRandom.hex(6)
    json.role i.role
    json.path profile_path(i)
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
    json.current_page @feedbackers.current_page
    json.next_page @feedbackers.next_page
    json.prev_page @feedbackers.previous_page
    json.per_page @feedbackers.per_page
    json.total_pages @feedbackers.total_pages
    json.count @idea.feedbackers_counter.length
    json.label "People who gave feedback to #{@idea.name}"
  end

end