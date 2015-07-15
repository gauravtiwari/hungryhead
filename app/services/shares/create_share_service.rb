class CreateShareService

  def initialize(params, owner)
    @params = params
    @owner = owner
  end

  def create
    @share = Share.new @params
    @share.owner = @owner
    @share
  end

end