class UserWelcomeService

  def initialize(resource, profile_url)
    @resource = resource
    @profile_url = profile_url
  end

  def welcome
    create_activity
    AwardBadgeJob.set(wait: 5.seconds).perform_later(@resource, @resource, 1, msg, "User_#{@resource.id}")
  end

  def create_activity
    @resource.create_activity(key: 'user.create', owner: @resource, recipient: @resource, params: {
      user_name: @resource.name,
      verb: "joined",
      action: "hungryhead",
      user_path: profile_url,
        avatar: @resource.avatar.url(:avatar)
      }
    )
  end

  def msg
    "<a href='#{profile_url}'>You</a> have earned a community badge for joining hungryhead</a>".html_safe
  end

end