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
        @activity = @user.activities.create!(trackable: @mention, verb: 'mentioned', type: 'Notification', recipient: mentionable, type: 'Notification', key: 'create')
        MentionNotificationService.new(@activity).notify
      end
    end
	end

end
