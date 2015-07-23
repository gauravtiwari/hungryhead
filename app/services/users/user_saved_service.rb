class UserSavedService

  include Rails.application.routes.url_helpers

  def initialize(user)
    @user = user
  end

  def call
    soulmate_loader
    flush_cache
  end

  private

  def flush_cache
    total = User.latest.revrange(0, 20).inject{|sum,x| sum.to_i + x.to_i }
    keys = ["#{self.to_s.downcase.pluralize}:trending:#{total}", "#{self.to_s.downcase.pluralize}:popular:#{total}", "#{self.to_s.downcase.pluralize}:latest:#{total}"]
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