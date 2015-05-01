class CreateVoteNotificationService

  def initialize(user)
    @user = user
    @vote = vote.user
    @votable = vote.votable
  end

  def create
    @activity = @user.notifications.create!(
      trackable: @vote,
      recipient: @votable,
      verb: 'voted',
      key: 'vote.create'
    )
    cache(@activity)
  end

  def cache(activity)
    CreateNotificationCacheService.new(activity).create
  end

end