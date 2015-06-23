class SchoolsController < ApplicationController
  before_filter :authenticate_user!, except: :autocomplete_school_name
  before_filter :check_terms, except: :autocomplete_school_name
  before_action :set_schools, only: [:latest_ideas, :card, :show, :edit, :people, :ideas, :update, :destroy]

  #Respond JSON
  respond_to :html, :json
  #Autocomplete school
  autocomplete :school, :name, :full => true, :extra_data => [:domain]
  #Verify user access
  after_action :verify_authorized, only: [:new, :create, :update, :destroy]
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  layout 'home'

  # GET /schools
  # GET /schools.json
  def index
    @schools = School.paginate(:page => params[:page], :per_page => 20)
  end

  # GET /schools/1
  # GET /schools/1.json

  def show
    @students = @school.fetch_users.select{|u| u.state = "published"}.take(10)
  end

  def latest_ideas
    @ideas = @school.fetch_ideas.select{|u| u.status = "published"}.take(10)
    respond_to do |format|
      format.js
    end
  end

  def card
    render partial: 'shared/school_card'
  end

  def people
    @users = @school.fetch_users.select{|u| u.state = "published"}.paginate(:page => params[:page], :per_page => 20)
    if request.xhr?
      render :partial=>"schools/students"
    end
  end

  def events
    @ideas = Event.where(school_id: @school.id).limit(4)
    @students = User.where(school_id: @school.id).paginate(:page => params[:page], :per_page => 20)
    if request.xhr?
      render :partial=>"schools/content/students"
    end
  end

  def ideas
    @ideas = @school.fetch_ideas.select{|u| u.status = "published"}.paginate(:page => params[:page], :per_page => 20)
    if request.xhr?
      render :partial=>"schools/ideas"
    end
  end

  # GET /schools/new
  def new
    @school = School.new
  end

  # GET /schools/1/edit
  def edit
  end

  # POST /schools
  # POST /schools.json
  def create
    @school = School.new(schools_params)

    respond_to do |format|
      if @school.save
        format.html { redirect_to @school, notice: 'School was succesfully created.' }
        format.json { render :show, status: :created, location: @school }
      else
        format.html { render :new }
        format.json { render json: @school.errors, status: :unprocesable_entity }
      end
    end
  end

  # PATCH/PUT /schools/1
  # PATCH/PUT /schools/1.json
  def update
    authorize @school
    respond_to do |format|
      if @school.update(schools_params)
        format.html { redirect_to @school, notice: 'School was succesfully updated.' }
        format.json { render :show, status: :ok, location: @school }
      else
        format.html { render :edit }
        format.json { render json: @school.errors, status: :unprocesable_entity }
      end
    end
  end

  # DELETE /schools/1
  # DELETE /schools/1.json
  def destroy
    @school.destroy
    respond_to do |format|
      format.html { redirect_to schools_url, notice: 'School was succesfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_schools
      @user = current_user
      id = params[:id] || params[:slug]
      @school = School.fetch_by_slug(id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def schools_params
       params.require(:school).permit(:id, :email, :name, :description, :cover_left, :cover_position, :website, :logo, :cover, :location_list, :established)
    end
end
