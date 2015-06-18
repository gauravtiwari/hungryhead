json.idea do
  json.(@idea, :uuid, :name, :slug, :description, :high_concept_pitch, :profile, :elevator_pitch, :sections, :video_html, :video)
  json.logo do
    json.url @idea.logo.url(:avatar) if @idea.logo
  end

  json.cover do
    json.url @idea.cover.present? ? @idea.cover.url(:cover) : "#{root_url}assets/building-ecosystem.png"
    json.top @idea.cover_position if @idea.cover
    json.left @idea.cover_left if @idea.cover
    json.has_cover @idea.cover.present?
  end

  json.school_name @idea.school.name
  json.school_url profile_path(@idea.school)
  json.location @idea.location_list.each do |location|
    json.name location
    json.url tag_path(location.parameterize)
  end
  json.market @idea.market_list.each do |market|
    json.name market
    json.url tag_path(market.parameterize)
  end
  json.form action: idea_path(@idea), method: "PUT", idea_id: @idea.uuid
end

json.stats do
  json.followers_counter @idea.followers_counter.value
  json.feedbacks_counter @idea.feedbackers_counter.value
  json.investments_counter @idea.investors_counter.value
  json.votes_counter @idea.votes_counter.value
  json.raised @idea.balance
end

json.meta do
  json.idea_name @idea.name
  json.idea_path idea_path(@idea)
  json.is_owner @idea.in_team?(current_user)
end

