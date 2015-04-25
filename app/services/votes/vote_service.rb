class VoteService

  def initialize(user, votable, profile_url)
    @user = user
    @profile_url = profile_url
    @votable = votable
  end

  def vote
    @votable.voted_by @user
    @votable.votes_counter.increment
    @votable.voters_ids.add(@user.id, Time.now.to_i)
    send_vote_notification
  end

  def unvote
    @votable.unvoted_by @user
    @votable.votes_counter.decrement if @votable.votes_counter.value > 0
    @votable.voters_ids.delete(@user.id)
    UnvoteNotificationJob.perform_later(@votable)
  end

  def msg
     msg = "<a href='#{@profile_url}'>#{@user.name}</a> voted your " + "#{@votable.class.to_s.downcase}".html_safe
  end

  def send_vote_notification
    @voter = @votable.class.to_s == "Idea" ? @votable.student : @votable.user
    if @user != @voter
      NewNotificationJob.perform_later(@user, @votable, msg)
    end
  end

end