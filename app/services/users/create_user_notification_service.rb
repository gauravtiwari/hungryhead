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
    @user.school.people_counter.reset if @user.school_id.present?
    @user.school.people_counter.incr(User.from_school(@user.school_id).size) if @user.school_id.present?

    #Cache latest user & sorted set for global leaderboard
    User.latest.add(@user.id, @user.created_at.to_i + @user.id)
    #Add leaderboard score
    User.leaderboard.add(@user.id, @user.points)
    User.trending.add(@user.id, 1)

    User.latest.remrangebyrank(0, -20)

    #Send notification to listing
    Pusher.trigger_async("users-channel",
      "new_user",
      { data: @user.card_json }.to_json
    )

  end

end