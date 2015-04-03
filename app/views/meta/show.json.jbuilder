json.meta do
  json.(@meta, :id, :name, :description, :profile, :sections, :video_html, :video)
  json.logo do
    json.url @meta.logo.url(:avatar)
  end
  json.cover do
    json.url @meta.cover.url(:cover)
  end
  json.is_owner current_user.admin? if current_user
  json.form action: update_meta_path(@meta), method: "PUT", meta_id: @meta.id, csrf_param: request_forgery_protection_token, csrf_token: form_authenticity_token
end