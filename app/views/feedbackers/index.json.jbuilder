json.payload do

  json.listings @feedbackers.each do |feedbacker|
    json.cache! [ "feedbackers", feedbacker ], expires_in: 2.hours do
        json.name feedbacker.name
        json.avatar feedbacker.avatar.url(:avatar)
        json.uuid feedbacker.uid
        json.role feedbacker.role
        json.path profile_path(feedbacker)
        json.locations feedbacker.location_list.each do |tag|
            json.tag tag
            json.url tag_people_path(tag.parameterize)
        end
        json.about_me feedbacker.mini_bio
        json.user_name_badge feedbacker.user_name_badge
        json.is_following feedbacker.followed_by?(current_user)
        json.followed followed?(feedbacker)
        json.not_current_user feedbacker != current_user
    end
  end

  json.meta do
    json.cache! [ @idea, "feedbackers",  @feedbackers.current_page ], expires_in: 2.hours do
        json.current_page @feedbackers.current_page
        json.next_page @feedbackers.next_page
        json.prev_page @feedbackers.previous_page
        json.per_page @feedbackers.per_page
        json.total_pages @feedbackers.total_pages
        json.count @idea.feedbackers_counter.value
        json.label "People who gave feedback to #{@idea.name}"
    end
  end

end