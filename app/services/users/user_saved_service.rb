class UserSavedService

  include Rails.application.routes.url_helpers

  def initialize(user)
    @user = user
  end

  def call
    load_into_soulmate
    rebuild_notifications if rebuild_cache? && has_notifications?
  end

  private

  def rebuild_notifications
    #rebuild user feed every time name and avatar update.
    RebuildNotificationsCacheJob.set(wait: 5.seconds).perform_later(@user.id)
  end

  #Load data to redis using soulmate after_save
  def load_into_soulmate
    #Seperate index for each user type
    unless @user.admin?
      if @user.type == "Student"
        soulmate_loader("students")
      elsif @user.type == "Mentor"
        soulmate_loader("mentors")
      elsif @user.type == "Teacher"
        soulmate_loader("teachers")
      end
    end
  end

  def soulmate_loader(type)
    #instantiate soulmate loader to re-generate search index
    loader = Soulmate::Loader.new(type)
    loader.add(
      "term" => @user.name,
      "image" => @user.avatar.url(:avatar),
      "description" => @user.mini_bio,
      "id" => @user.id,
      "data" => {
        "link" => profile_path(@user)
      }
    )
  end

  def rebuild_cache?
    #check if basic info changed and user is not new
    @user.name_changed? || @user.avatar_changed? || @user.username_changed? && !@user.id_changed?
  end

  def has_notifications?
    #check if user has notifications
    @user.ticker.members.length > 0
  end

end