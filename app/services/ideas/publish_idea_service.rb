class PublishIdeaService

  def initialize(idea, user)
    @idea = idea
    @user = user
  end

  def publish
    @idea.published!
    @idea.everyone!
    #If user not entrepreneur award badge
    if !@user.entrepreneur?
      award_badge
    end
    IdeaNotificationService.new(@idea, @user).notify
  end

  private

  #Award Badge to user
  def award_badge
    @user.entrepreneur!
    AwardBadgeJob.set(wait: 10.seconds).perform_later(@user.id, 2, "Idea_#{@idea.id}")
  end

end