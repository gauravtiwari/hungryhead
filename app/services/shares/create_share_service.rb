class CreateShareService
  def initialize(params, user, idea)
    @params = params
    @user = user
    @idea = idea
  end

  def create
    @share = Share.new @params
    @share.user =
    @share.parameters = {shareable_name: @idea.name}
    @share.shareable = @idea
    @share.status =  1
    @share
  end

end