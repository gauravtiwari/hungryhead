class SchoolsController < ApplicationController
  before_filter :authenticate_user!, except: :autocomplete_school_name
  before_filter :check_terms, except: :autocomplete_school_name
  before_action :set_schools, except: [:new, :create, :autocomplete_school_name]

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
    @students = @school.fetch_students.select{|u| u.state == "published"}.sort { |x,y| y.created_at <=> x.created_at }.first(10)
  end

  # GET /schools/1/dashboard
  def dashboard
  end

  def latest_ideas
    @ideas = @school.fetch_ideas.select{|u| u.status == "published"}.sort { |x,y| y.created_at <=> x.created_at }.first(10)
    respond_to do |format|
      format.js
    end
  end

  def card
    render partial: 'shared/school_card'
  end

  def people
    @users = @school.fetch_students.select{|u| u.state == "published"}.sort { |x,y| y.created_at <=> x.created_at }.paginate(:page => params[:page], :per_page => 20)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def events
    @events = @school.fetch_events.select{|u| u.status == "open"}.sort { |x,y| y.created_at <=> x.created_at }.paginate(:page => params[:page], :per_page => 20)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def ideas
    @ideas = @school.fetch_ideas.select{|u| u.status == "published"}.sort { |x,y| y.created_at <=> x.created_at }.paginate(:page => params[:page], :per_page => 20)
    if request.xhr?
      render :partial=>"schools/ideas"
    end
  end

  # GET /school/1/comments
  def comments
    @comments = @school.root_comments.reorder(id: :desc).paginate(:page => params[:page], :per_page => 10)
    respond_to do |format|
      format.html
      format.js
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
       params.require(:school).permit(:id, :email, :name, :phone, :description, :cover_left, :cover_position, :website_url, :twitter_url, :facebook_url, :logo, :cover, :location_list)
    end
end
