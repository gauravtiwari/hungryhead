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
        @mention = mentionable.mentions.create!(user: @user, mentioner: @mentioner)
        @activity = @user.notifications.create!(trackable: @mention, verb: 'mentioned', recipient: mentionable, key: 'mention.create')
        NotificationCacheService.new(@activity).cache
        MentionNotificationService.new(@activity).notify if @user != mentionable
      end
    end
	end

end
