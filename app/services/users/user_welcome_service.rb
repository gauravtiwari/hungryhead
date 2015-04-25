class Users::UserWelcomeService

  def initialize(resource, profile_url)
    @resource = resource
    @profile_url = profile_url
  end

  def welcome
    AwardBadgeJob.set(wait: 5.seconds).perform_later(@resource, @resource, 1, msg, "User_#{@resource.id}")
  end

  def msg
    "<a href='#{@profile_url}'>You</a> have earned a community badge for joining hungryhead</a>".html_safe
  end

end