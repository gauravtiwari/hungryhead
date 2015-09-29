json.payload do
  # Duplicate view to be refactored
  json.listings @investors.each do |investor|
    json.cache! [ "investors", investor ], expires_in: 2.hours do
        json.name investor.name
        json.avatar investor.get_avatar
        json.uuid investor.uid
        json.role investor.role
        json.path profile_path(investor)
        json.locations investor.location_list.each do |tag|
            json.tag tag
            json.url tag_people_path(tag.parameterize)
        end
        json.about_me investor.mini_bio
        json.user_name_badge investor.name_badge
        json.is_following investor.followed_by?(current_user)
        json.followed followed?(investor)
        json.not_current_user investor != current_user
    end
  end

  json.meta do
    json.cache! [ @idea, "investors",  @investors.current_page ], expires_in: 2.hours do
        json.current_page @investors.current_page
        json.next_page @investors.next_page
        json.prev_page @investors.previous_page
        json.per_page @investors.per_page
        json.total_pages @investors.total_pages
        json.count @idea.investors_counter.value
        json.label "People who invested in #{@idea.name}"
    end
  end

end