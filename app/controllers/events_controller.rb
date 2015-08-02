class EventsController < ApplicationController
  before_action :set_event, except: [:index, :new, :create]

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
    @owner = @event.owner
    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /events/1/publish
  def publish
    if @event.profile_complete?
      @event.published!
      @event.everyone!
      if @event.published?
        CreateActivityJob.perform_later(@event.id, @event.class.to_s)
        flash[:notice] = "Your event profile was successfully published to: #{@event.privacy.capitalize}"
      else
        flash[:notice] = "Something went wrong, please try again."
      end
    else
      flash[:notice] = "Your event profile isn't complete. Please complete your profile and try publishing again."
    end
    respond_to do |format|
      format.js
    end
  end

  # PUT /events/1/unpublish
  def unpublish
    @event.draft!
    @event.me!
    if @event.draft?
      DeleteActivityJob.perform_later(@event.id, @event.class.to_s)
      flash[:notice] = "Your event profile was successfully unpublished"
    else
      flash[:notice] = "Something went wrong, please try again."
    end
    respond_to do |format|
      format.js {render :publish}
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
        format.js {render :show}
      else
        format.html { render :edit }
        format.js {render :edit}
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
    params.require(:event).permit(:status, :title, :description, :owner_id, :owner_type, :address,
    :start_time, :end_time, :eventable_id, :space, :cover_position, :cover_left, :featured, :cover, :excerpt, :category_list)
  end
end
