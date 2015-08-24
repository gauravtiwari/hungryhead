class UserSavedService

  include Rails.application.routes.url_helpers

  def initialize(user)
    @user = user
  end

  def call
    soulmate_loader
    expire_cache
  end

  private

  def expire_cache
    keys = [
      "popular_20_#{@user.class.to_s.pluralize.downcase}",
      "latest_20_#{@user.class.to_s.pluralize.downcase}",
      "trending_20_#{@user.class.to_s.pluralize.downcase}"
    ]
    keys.each do |key|
      Rails.cache.delete(key)
    end
  end

  def soulmate_loader
    #instantiate soulmate loader to re-generate search index
    loader = Soulmate::Loader.new('people')
    loader.add(
      "term" => @user.name,
      "name_badge" => @user.name_badge,
      "image" => @user.get_avatar,
      "description" => @user.mini_bio,
      "id" => @user.id,
      "data" => {
        "link" => profile_path(@user)
      }
    )
  end

end