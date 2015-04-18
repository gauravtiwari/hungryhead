class LikeService

  def initialize(user, votable, profile_url)
    @user = user
    @profile_url = profile_url
    @votable = votable
  end

  def like
    @votable.liked_by @user
    send_like_notification
  end

  def unlike
    @votable.unliked_by @user
    UnlikeNotificationJob.perform_later(@votable)
  end

  def msg
     msg = "<a href='#{@profile_url}'>#{@user.name}</a> liked your " + "#{@votable.class.to_s.downcase}".html_safe
  end

  def send_like_notification
    @voter = @votable.class.to_s == "Idea" ? @votable.student : @votable.user
    if @user != @voter
      NewNotificationJob.perform_later(@user, @votable, msg)
    end
  end

end