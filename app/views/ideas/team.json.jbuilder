json.payload do

  json.listings @team.each do |member|
    json.cache! [ member], expires_in: 2.hours do
        json.name member.name
        json.avatar member.get_avatar
        json.uuid SecureRandom.hex(10)
        json.role member.role
        json.path profile_path(member)
        json.locations member.location_list.each do |tag|
            json.tag tag
            json.url tag_people_path(tag.parameterize)
        end
        json.about_me member.mini_bio
        json.user_name_badge member.name_badge
        json.is_following member.followed_by?(current_user)
        json.followed followed?(member)
        json.not_current_user member != current_user
    end
  end

  json.meta do
    json.cache! [ "members", @team.size ], expires_in: 2.hours do
        json.current_page @team.current_page
        json.next_page @team.next_page
        json.prev_page @team.previous_page
        json.per_page @team.per_page
        json.total_pages @team.total_pages
        json.count @idea.team_ids.length
        json.label "#{@idea.name} team members"
    end
  end

end