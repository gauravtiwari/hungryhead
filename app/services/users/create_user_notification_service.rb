class CreateUserNotificationService

  include Rails.application.routes.url_helpers

  def initialize(user)
    @user = user
  end

  def create
    @user.activities.create!(
      trackable: @user,
      verb: 'joined',
      recipient: @user,
      key: 'user.create'
    )
    publish_user #publish user
    increment_counters
  end

  def publish_user
    @user.published!
    @user.save
  end

  def increment_counters
    #Increment counters
    @user.school.students_counter.increment if @user.school_id.present? && @user.type == "Student"
    #Cache lists for school
    @user.school.latest_students << @user.id if @user.school_id.present? && @user.type == "Student"
    @user.school.latest_faculties << @user.id if @user.school_id.present? && @user.type == "Teacher"

    #Cache sorted set for global leaderboard
    User.latest << @user.id unless @user.type == "User"

    #Add leaderboard score
    User.leaderboard.add(@user.id, @user.points)
    User.trending.add(@user.id, 1)

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
      url: profile_path(user),
      description: user.mini_bio
    }
  end

end