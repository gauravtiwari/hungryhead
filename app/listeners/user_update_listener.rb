class UserUpdateListener

  def after_commit(user)
    if user.previous_changes[:name].present? || user.previous_changes[:avatar].present?
      #Load data for search
      load_into_soulmate(user) unless user.admin?
      #rebuild user feed after every name and avatar update.
      RebuildNotificationsCacheJob.set(wait: 5.seconds).perform_later(user.id)
      #Find all followers and followings and update their feed.
      User.where(id: user.followers_ids.members | user.followings_ids.members).find_each do |user|
        RebuildNotificationsCacheJob.set(wait: 5.seconds).perform_later(user.id)
      end
    end
  end

  def after_create(user)
    load_into_soulmate(user) unless user.admin?
    user.school.students_counter.increment if school
    add_fullname(user)
    seed_fund(user) unless user.admin?
    seed_settings(user) unless user.admin?
  end

  def after_destroy(user)
    #remove data from search
    type = user_type_key(user)
    loader = Soulmate::Loader.new(type)
    loader.remove("id" => user.id)
    #Decrement counters
    user.school.students_counter.decrement if user.school && user.school.students_counter.value > 0
    #Delete user feed job
    DeleteUserFeedJob.perform_later(user.id, user.class.to_s)
  end

  private

  # returns and adds first_name and last_name to database
  def add_fullname(user)
    words = user.name.split(" ")
    user.first_name = words.first
    user.last_name =  words.last
  end

  #Seeds amount into database on: :create
  def seed_fund(user)
    user.fund = {balance: 1000}
  end

  #Seeds settings into database on: :create
  def seed_settings(user)
    user.settings = {
      theme: 'solid',
      idea_notifications: true,
      feedback_notifications: true,
      investment_notifications: true,
      follow_notifications: true,
      note_notifications: true,
      weekly_mail: true
    }
  end

  def load_into_soulmate(user)
    unless user.admin?
      type = user_type_key(user)
      loader = Soulmate::Loader.new(type)
      loader.add(
        "term" => user.name,
        "image" => user.avatar.url(:avatar),
        "description" => user.mini_bio,
        "id" => user.id,
        "data" => {
          "link" => Rails.application.routes.url_helpers.profile_path(user)
        }
      )
    end
  end

  def user_type_key(user)
    if user.type == "Student"
      return "students"
    elsif user.type == "Mentor"
      return "mentors"
    elsif user.type == "Teacher"
      return "teachers"
    end
  end

end