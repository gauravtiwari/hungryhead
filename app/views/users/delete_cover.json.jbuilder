json.user do
	json.avatar do
		json.url @user.avatar.url(:avatar) if @user.avatar
	end
	json.cover do
		json.url @user.cover.url(:cover) if @user.cover
		json.position @user.cover_position if @user.cover
	end

	json.is_owner @user == current_user
	json.form delete_action: profile_delete_cover_path(@user), action: user_path(@user), method: "PUT", csrf_param: request_forgery_protection_token, csrf_token: form_authenticity_token
end
