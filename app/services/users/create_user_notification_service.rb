class CreateUserNotificationService

  include Rails.application.routes.url_helpers

  def initialize(user)
    @user = user
  end

  def create
    publish_user #publish user
    increment_counters #update counters
  end

  def publish_user
    @user.published!
    @user.save
  end

  def increment_counters
    #Increment counters
    @user.school.people_counter.reset
    @user.school.people_counter.incr(User.from_school(@user.school_id).size) if @user.school_id.present?
    #Cache lists for school
    @user.school.published_people.add(@user.id, @user.created_at.to_i + @user.id) if @user.school_id.present?

    #Cache latest user & sorted set for global leaderboard
    User.latest.add(@user.id, @user.created_at.to_i + @user.id)
    #Add leaderboard score
    User.leaderboard.add(@user.id, @user.points)
    User.trending.add(@user.id, 1)

    User.latest.remrangebyrank(20, User.latest.members.length)

    #Send notification to listing
    Pusher.trigger_async("users-channel",
      "new_user",
      {data: user_json(@user)}.to_json
    )

  end

  #User JSON
  def user_json(user)
    {
      id: user.uid,
      name: user.name,
      name_badge: user.user_name_badge,
      avatar: user.avatar.url(:avatar),
      url: profile_card_path(user),
      description: user.mini_bio
    }
  end

end