class CreateMentionService

	def initialize(mentioner, mentionable_content)
		@mentionable_content = mentionable_content
		@mentioner = mentioner
	end
	
	def mention
	  @mentionable_content.scan(/@\w+/).each do |username|
        user = User.friendly.find_by_username(username.gsub('@', ''))
        if user
          NewMentionNotificationJob.perform_later(@mentioner.user, user)
        end
      end
	end
end