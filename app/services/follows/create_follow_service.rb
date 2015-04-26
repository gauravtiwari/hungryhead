class CreateFollowService
	def initialize(user, followable)
		@user = user
    @followable = followable
	end

	def create
    if @followable.follower?(@user)
      unfollow
    else
      follow
    end
	end

  private

  def follow
    @follow = @user.follows.create!(followable: @followable)
    @activity = @user.activities.create!(trackable: @follow, verb: 'followed', type: 'Notification', recipient: @followable, key: 'create')
    FollowNotificationService.new(@activity).notify unless @activity.recipient_type == "School"
  end

  def unfollow
    @user.follows.where(followable: @followable).each do |follow|
      follow.destroy
    end
  end

end
