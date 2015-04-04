class SchoolsController < ApplicationController
  before_filter :authenticate_user!, only: [:show, :activities, :students, :ideas, :update, :edit]
  before_action :set_schools, only: [:notifications, :show, :activities, :edit, :students, :ideas, :update, :destroy]
  respond_to :html, :json
  autocomplete :schools, :name, :full => true

  # GET /schools
  # GET /schools.json
  def index
    @school = School.all
  end

  # GET /schools/1
  # GET /schools/1.json
  
  def show
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
        format.html { redirect_to @schools, notice: 'School was succesfully updated.' }
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
      @school = Organization.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def schools_params
       params.require(:school).permit(:id, :email, :name, :description, :website, :logo, :cover, :location, :established)
    end
end
