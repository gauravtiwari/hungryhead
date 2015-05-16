class UserCreatedService

  def initialize(user)
    @user = user
  end

  def call
    increment_counters
  end

  def increment_counters
    #Increment counters
    @user.school.students_counter.increment if @user.type == "Student"

    #Cache lists for school
    @user.school.latest_students << id if  @user.type == "Student"
    @user.school.latest_faculties << id if @user.type == "Teacher"

    #Cache sorted set for global leaderboard
    User.latest << id unless type == "User"

    #Add leaderboard score
    User.leaderboard.add(@user.id, @user.points)
    User.trending.add(@user.id, 1)
  end

end