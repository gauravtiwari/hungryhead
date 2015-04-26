class CreateVoteService

  def initialize(user, votable)
    @user = user
    @votable = votable
  end

  def create
    if @votable.voted?(@user)
      unvote
    else
      vote
    end
  end

  def vote
    @vote = @votable.votes.create!(voter: @user)
    @activity = @user.activities.create!(trackable: @vote, recipient: @votable, type: 'Notification', verb: 'voted', key: 'vote.create')
    send_notification @activity
    true
  end

  def unvote
    @user.votes.where(votable: @votable).each do |vote|
      vote.destroy
      DeleteUserFeedJob.perform_later(vote.id, vote.class.to_s)
    end
    false
  end

  private

  def send_notification activity
    @voter = @votable.class.to_s == "Idea" ? @votable.student : @votable.user
    if @user != @voter
      VoteNotificationService.new(activity).notify
    end
  end

end