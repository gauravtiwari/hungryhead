class UserSavedService

  include Rails.application.routes.url_helpers

  def initialize(user)
    @user = user
  end

  def call
    soulmate_loader
  end

  private

  def soulmate_loader
    #instantiate soulmate loader to re-generate search index
    loader = Soulmate::Loader.new('people')
    loader.add(
      "term" => @user.name,
      "image" => @user.get_avatar,
      "description" => @user.mini_bio,
      "id" => @user.id,
      "data" => {
        "link" => profile_path(@user)
      }
    )
  end

end