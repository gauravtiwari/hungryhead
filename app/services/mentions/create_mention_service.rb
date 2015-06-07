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
        @activity = @user.notifications.create!(
          trackable: @mention,
          verb: 'mentioned',
          parent_id: find_parent_activity,
          recipient: mentionable,
          key: 'mention.create',
          unread: true
        )
        cache(@activity)
      end
    end
	end

  def find_parent_activity
    if @mentioner.class.to_s == "Comment"
      Activity.where(trackable: @mentioner.commentable).first.uuid
    else
      Activity.where(trackable: @mentioner).first.uuid
    end
  end

  def cache(activity)
    CreateNotificationCacheService.new(activity).create
  end

end
