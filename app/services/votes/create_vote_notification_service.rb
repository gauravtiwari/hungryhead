class CreateVoteNotificationService
  def initialize(vote)
    @user = vote.voter
    @vote = vote
    @votable = vote.votable
  end

  def create
    if @user.activities.where(trackable: @vote).empty?
      @activity = @user.activities.create!(
        trackable: @vote,
        recipient: @votable,
        parent_id: find_parent_activity,
        verb: 'voted',
        key: 'vote.create',
        is_notification: true
      )
      cache(@activity)
    end
  end

  def cache(activity)
    CreateNotificationCacheService.new(activity).create
  end

  def find_parent_activity
    if @vote.votable_type == 'Comment'
      @activity = Activity.where(trackable: @votable.commentable).first
    else
      @activity = Activity.where(trackable: @votable).first
    end
    # Increment parent score
    Activity.popular.incr(@activity.id, 5) unless @activity.blank?
    # return uuid
    @activity.uuid
  end
end
