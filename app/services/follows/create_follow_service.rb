class CreateFollowService
	def initialize(user, followable)
		@user = user
    @followable = followable
	end

  def follow
    @user.followings.new(followable: @followable)
  end

  def unfollow
    @user.followings.where(followable: @followable).first
  end

end
