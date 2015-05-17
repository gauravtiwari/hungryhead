class SchoolsController < ApplicationController
  before_filter :authenticate_user!, only: [:show, :activities, :students, :ideas, :update, :edit]
  before_action :authenticate_admin_user!, only: [:new, :create, :destroy, :edit]
  before_action :set_schools, only: [:latest_students, :latest_ideas, :latest_faculties, :card, :notifications, :show, :activities, :edit, :students, :ideas, :update, :destroy]
  respond_to :html, :json
  autocomplete :school, :name, :full => true, :extra_data => [:logo, :email]

  layout 'home'

  # GET /schools
  # GET /schools.json
  def index
    @schools = School.paginate(:page => params[:page], :per_page => 12)
  end

  # GET /schools/1
  # GET /schools/1.json

  def show
    ids = User.where(school_id: @school.id).pluck(:id)
    @activities = Activity.where(user_id: ids, published: true)
    .includes(:trackable, :user, :recipient)
    .order(id: :desc)
    .paginate(:page => params[:page], :per_page => 20)
  end

  def latest_students
    @students = Student.find(@school.latest_students.values).paginate(:page => params[:page], :per_page => 5)
    render json: Oj.dump({
      list: @students.map{|user| {id: user.id, name: user.name, name_badge: user.user_name_badge, url: profile_path(user), description: user.mini_bio}},
      type: 'Latest Students',
      next_page: @students.next_page
      }, mode: :compat)
  end

  def latest_ideas
   @ideas = Idea.find(@school.latest_ideas.values).paginate(:page => params[:page], :per_page => 5)
   render json: Oj.dump({
    list: @ideas.map{|idea| {id: idea.id, name: idea.name, name_badge: idea.name_badge, url: idea_path(idea), description: idea.high_concept_pitch}},
    type: 'Latest Ideas',
    next_page: @ideas.next_page
    }, mode: :compat)
  end

  def latest_faculties
    @faculties = Teacher.find(@school.latest_faculties.values).paginate(:page => params[:page], :per_page => 5)
    render json: Oj.dump({
     list: @faculties.map{|user| {id: user.id, name: user.name, name_badge: user.user_name_badge, url: profile_path(user), description: user.mini_bio}},
     type: 'Latest Faculties',
     next_page: @faculties.next_page
     }, mode: :compat)
  end

  def card
    render partial: 'shared/school_card'
  end

  def students
    @ideas = Idea.where(school_id: @school.id).limit(4)
    @students = User.where(school_id: @school.id).paginate(:page => params[:page], :per_page => 20)
    if request.xhr?
      render :partial=>"schools/content/students"
    end
  end

  def ideas
    @entrepreneurs = User.where(school_id: @school.id).limit(4)
    @ideas = Idea.where(school_id: @school.id).paginate(:page => params[:page], :per_page => 20)
    if request.xhr?
      render :partial=>"schools/content/ideas"
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
      @school = School.find(id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def schools_params
       params.require(:school).permit(:id, :email, :name, :description, :cover_left, :cover_position, :website, :logo, :cover, :location_list, :established)
    end
end
