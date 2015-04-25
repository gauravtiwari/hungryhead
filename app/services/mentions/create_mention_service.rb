class CreateMentionService
	def initialize(mentioner)
		@mentioner_content = mentioner.body
		@user = mentioner.user
    @mentioner = mentioner
	end

	def mention
	  @mentioner_content.scan(/@\w+/).each do |username|
      mentionable = User.friendly.find_by_username(username.gsub('@', ''))
      if mentionable.present?
        @mention = @user.mentions.create!(mentionable: mentionable, mentioner: @mentioner)
        @activity = @user.notifications.create!(trackable: @mention, recipient: mentionable)
        MentionNotificationService.new(@activity).notify
      end
    end
	end

end
