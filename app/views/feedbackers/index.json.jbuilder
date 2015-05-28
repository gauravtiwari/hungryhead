json.payload do

  json.listings @feedbackers.each do |feedbacker|
    json.name feedbacker.name
    json.avatar feedbacker.avatar.url(:avatar)
    json.uuid feedbacker.uid
    json.role feedbacker.role
    json.path profile_path(feedbacker)
    json.locations feedbacker.location_list.each do |tag|
        json.tag tag
        json.url tag_people_path(tag.parameterize)
    end
    json.about_me follower.mini_bio
    json.user_name_badge follower.user_name_badge
    json.is_following feedbacker.followed_by?(current_user)
    json.followed followed?(feedbacker)
    json.not_current_user feedbacker != current_user
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