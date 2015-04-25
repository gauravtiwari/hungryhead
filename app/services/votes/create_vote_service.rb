class CreateVoteService

  def initialize(user, votable)
    @user = user
    @votable = votable
  end

  def create
    if @votable.voted?(user)
      unvote
    else
      vote
    end
  end

  def vote
    @vote = @votable.votes.create!(voter: @user)
    increment_counters
    create_activity
    true
  end

  def unvote
    @votable.unvoted_by @user
    delete_activity
    decrement_counters
    false
  end

  private

  def increment_counters
    @votable.votes_counter.increment
    @votable.voters_ids.add(@user.id, Time.now.to_i)
  end

  def decrement_counters
    @votable.votes_counter.decrement if @votable.votes_counter.value > 0
    @votable.voters_ids.delete(@user.id)
  end

  def create_activity
    @activity = @user.activities.create!(trackable: @votable, recipient: @votable, type: 'Notification')

    @voter = @votable.class.to_s == "Idea" ? @votable.student : @votable.user
    if @user != @voter
      VoteNotificationService.new(@activity).notify
    end
  end

  def delete_activity
    @user.activities.where(trackable: @votable).find_each do |vote|
      vote.destroy if vote.present?
    end
  end

end