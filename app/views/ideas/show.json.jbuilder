json.idea do
  json.cache! ["idea_show_json", @idea, @idea.in_team?(current_user) ? "team" : "guest"], expires_in: 2.hours do
    json.(@idea, :uuid, :name, :slug, :looking_for_team, :description,
      :high_concept_pitch, :market, :business_model, :value_propositions,
      :problems, :solutions, :profile, :elevator_pitch)

    json.logo do
      json.url @idea.get_avatar if @idea.logo
    end

    json.cover do
      json.url @idea.cover.present? ? @idea.cover.url(:cover) : "#{root_url}assets/building-ecosystem.png"
      json.top @idea.cover_position if @idea.cover
      json.left @idea.cover_left if @idea.cover
      json.has_cover @idea.cover.present?
    end

    json.markets @idea.market_list.each do |market|
      json.name market
      json.url tag_path(market.parameterize)
    end
    json.form action: idea_path(@idea), method: "PUT", idea_id: @idea.uuid
  end
end

json.form delete_action: profile_delete_cover_path(@idea), action: idea_path(@idea), method: "PUT"

json.stats do
  json.views_counter @idea.views_counter.value
  json.feedbacks_counter @idea.feedbackers_counter.value
  json.investments_counter @idea.investors_counter.value
  json.votes_counter @idea.votes_counter.value
  json.raised @idea.balance
end

json.meta do
  json.cache! ["meta", @idea, current_user], expires_in: 2.hours do
    json.idea_name @idea.name
    json.idea_path idea_path(@idea)
    json.is_owner @idea.in_team?(current_user)
  end
end

