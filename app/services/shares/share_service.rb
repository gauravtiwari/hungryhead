class ShareService
  def initialize(params, user, idea)
    @params = params
    @user = user
    @idea = idea
  end

  def create
    @share = Share.new @params
    @share.update_attributes!(user: current_user, parameters: {shareable_name: @idea.name}, shareable: @idea, status: 1)
    @share
  end

end