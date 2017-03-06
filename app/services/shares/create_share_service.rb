class CreateShareService
  def initialize(params, user)
    @params = params
    @user = user
  end

  def create
    @share = Share.new @params
    @share.user = @user
    @share
  end
end
