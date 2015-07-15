class CreateEventService

  def initialize(params, owner)
    @params = params
    @owner = owner
  end

  def create
    @event = Event.new @params
    @event.owner = @owner
    @event
  end

end