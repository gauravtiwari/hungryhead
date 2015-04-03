module UserHelper
	def team_name_options
	    s = ''
	    User.all.where.not(id: current_user.id).each do |user|
	      s << "<option value='#{user.id}' data-img-src='#{user.avatar.url(:mini)}'>#{user.name}</option>"
	    end
	    s.html_safe
  	end

  	def is_owner?(user)
  		current_user == user
  	end
end
