class CreateMentionService
	def initialize(mentioner, mentionable_content, profile_url)
		@mentionable_content = mentionable_content
		@user = mentioner.user
    @mentioner = mentioner
		@profile_url = profile_url
	end

	def mention
	  @mentionable_content.scan(/@\w+/).each do |username|
        user = User.friendly.find_by_username(username.gsub('@', ''))
        if user.present?
          NewMentionNotificationJob.perform_later(@user, user, msg)
        end
      end
	end

	def msg
		msg = "<a href='#{@profile_url}'>#{@user.name}</a> mentioned you in a " + "#{@mentioner.class.to_s.downcase}".html_safe
	end
end
