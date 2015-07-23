class UserSavedService

  include Rails.application.routes.url_helpers

  def initialize(user)
    @user = user
  end

  def call
    soulmate_loader
    expire_home_listing if User.latest.revrange(0, 20).include?(@user.id.to_s)
  end

  private

  def expire_home_listing
    total = User.latest.revrange(0, 20).inject{|sum,x| sum.to_i + x.to_i }
    keys = ["#{User.to_s.downcase.pluralize}:trending:#{total}", "#{User.to_s.downcase.pluralize}:popular:#{total}", "#{User.to_s.downcase.pluralize}:latest:#{total}"]
    keys.each do |key|
      Rails.cache.delete(key)
    end
  end

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