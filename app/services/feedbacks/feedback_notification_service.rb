class FeedbackNotificationService

  def initialize(user_url, user, feedback_url, idea, idea_url)
    @user_url = user_url
    @user = user
    @feedback_url = feedback_url
    @idea = idea
    @idea_url = idea_url
  end

  def notify
    PostFeedbackJob.perform_later(@idea, @user, msg)
  end

  def msg
    msg = "<a href='#{@user_url}'>#{@user.name}</a> left a "+ "<a href='#{@feedback_url}'>feedback <i class='fa fa-fw ion-chatbubbles'></i> </a> for <a href='#{@idea_url}'>#{@idea.name}</a> ".html_safe
  end

end