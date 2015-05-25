class CreateVoteNotificationService

  def initialize(vote)
    @user = vote.voter
    @vote = vote
    @votable = vote.votable
  end

  def create
    @activity = @user.notifications.create!(
      trackable: @vote,
      recipient: @votable,
      parent_id: find_parent_activity,
      verb: 'voted',
      key: 'vote.create',
      unread: true
    )
    cache(@activity)
  end

  def cache(activity)
    CreateNotificationCacheService.new(activity).create
  end

  def find_parent_activity
    if @vote.votable_type == "Comment"
      @activity = Activity.where(trackable: @votable.commentable).first
      return @activity.id
    else
      @activity = Activity.where(trackable: @votable).first
      return @activity.id
    end
  end

end