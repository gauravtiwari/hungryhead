class CreateMentionService

	def initialize(mentioner, mentionable_content, profile_url)
		@mentionable_content = mentionable_content
		@mentioner = mentioner
		@profile_url = profile_url
	end
	
	def mention
	  @mentionable_content.scan(/@\w+/).each do |username|
        user = User.friendly.find_by_username(username.gsub('@', ''))
        if user.present?
          NewMentionNotificationJob.perform_later(@mentioner.user, user, msg)
        end
      end
	end

	def msg
		msg = "<a href='#{@profile_url}'>#{@mentioner.user.name}</a> mentioned you in a " + "#{@mentioner.class.to_s.downcase}".html_safe
	end
end