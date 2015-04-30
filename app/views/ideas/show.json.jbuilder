json.idea do
  json.(@idea, :id, :name, :description, :profile, :elevator_pitch, :sections, :video_html, :video)
  json.logo do
    json.url @idea.logo.url(:avatar) if @idea.logo
  end
  json.current_user_name current_user.name
  json.current_user_id current_user.id
  json.current_user_avatar current_user.avatar.url(:avatar)

  json.form action: idea_path(@idea), method: "PUT", idea_id: @idea.id, csrf_param: request_forgery_protection_token, csrf_token: form_authenticity_token
end

json.form do
	json.csrf_param request_forgery_protection_token
	json.csrf_token form_authenticity_token
	json.idea_slug @idea.slug
	json.idea_id @idea.id
end
json.meta do
	  json.user_name current_user.name
	  json.idea_name @idea.name
	  json.idea_path idea_path(@idea)
	  json.can_feedback @idea.feedbacked?(current_user)
	  json.is_owner @idea.in_team?(current_user)
	  json.user_avatar current_user.avatar.url(:mini)
end

json.idea_object  do
	json.name @idea.name
	json.id @idea.id
	json.slug @idea.slug
	json.description @idea.description
	json.profile @idea.profile
end
