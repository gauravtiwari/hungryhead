json.meta do
  json.(@meta, :id, :name, :description, :sections, :profile, :video, :video_html)
  json.logo do
    json.url @meta.logo.url(:avatar) if @meta.logo
  end
  json.current_user_name current_user.name
  json.current_user_avatar current_user.avatar.url(:avatar)

  json.form action: meta_path(@meta), method: "PUT", meta_id: @meta.id, csrf_param: request_forgery_protection_token, csrf_token: form_authenticity_token
end

json.form do
	json.csrf_param request_forgery_protection_token 
	json.csrf_token form_authenticity_token
	json.meta_slug @meta.slug 
	json.meta_id @meta.id
end
json.meta do 
	  json.user_name current_user.name
	  json.meta_name @meta.name
	  json.meta_path meta_path(@meta)
	  json.can_feedback policy(@meta).collaborator?
	  json.is_owner @meta.in_team?(current_user)
	  json.user_avatar current_user.avatar.url(:mini)
end
