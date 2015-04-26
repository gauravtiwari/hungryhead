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
    @user.follows.new(followable: @followable)
  end

  def unfollow
    @user.follows.where(followable: @followable).each do |follow|
      follow.destroy
    end
  end

end
