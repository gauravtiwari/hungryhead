class EventAttendeesController < ApplicationController
  before_action :set_event
  respond_to :json

  # GET /events
  # GET /events.json
  def index
    @events = User.all.paginate(:page => params[:page], :per_page => 20)
  end

  # POST /events
  # POST /events.json
  def join
    @event_attendee = EventAttendee.new(attendee: @user, event: @event)
    authorize @event
    if @event_attendee.save
      render json: {
        attending: true,
        attendees: @event.attendees_counter.value,
        attendee: current_user.card_json
      }
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def leave
    @event_attendee = EventAttendee.where(attendee: @user, event: @event).first
    authorize @event_attendee
    if @event_attendee.destroy
      render json: {
        attending: false,
        attendees: @event.attendees_counter.value,
        attendee: current_user.card_json
      }
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:event_id])
    @user = current_user
  end
end
