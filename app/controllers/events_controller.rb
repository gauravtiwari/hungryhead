class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  layout "home"
  # GET /events
  # GET /events.json
  def index
    @events = Event.all.paginate(:page => params[:page], :per_page => 20)
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
    @owner = params[:owner].constantize.find(params[:owner_id])
  end

  # GET /events/1/edit
  def edit
    @owner = @event.owner
    respond_to do |format|
      format.js {render :new}
    end
  end

  # POST /events
  # POST /events.json
  def create
    @event = CreateEventService.new(event_params).create
    respond_to do |format|
      if @event.save
        flash[:notice] = "Event was successfully created, redirecting..."
        format.js {render :show}
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def event_params
    params.require(:event).permit(:status, :title, :description, :owner_id, :owner_type, :address, :private,
    :start_time, :end_time, :eventable_id, :space, :cover, :excerpt, :category_list)
  end
end
