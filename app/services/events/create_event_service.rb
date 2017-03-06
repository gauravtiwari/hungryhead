class CreateEventService
  def initialize(params)
    @params = params
  end

  def create
    @event = Event.new @params
    @event
  end
end
