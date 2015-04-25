class CreateFollowService
	def initialize(user, followable)
		@user = user
    @followable = followable
	end

	def create
    if @followable.follower?(current_user)
      unfollow
    else
      follow
    end
	end

  def follow
    @user.follows.new(followable: @followable)
    @activity = @user.activities.create!(trackable: @followable, verb: 'followed', recipient: @followable, key: 'create')
    FollowNotificationService.new(@activity).notify unless @activity.recipient_type == "School"
  end

  def unfollow
    @user.follows.destroy(followable: @followable)
  end

end
