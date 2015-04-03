class InstitutionsController < ApplicationController
  before_filter :authenticate_user!, only: [:show, :activities, :students, :ideas, :update, :edit]
  before_action :set_institutions, only: [:notifications, :show, :activities, :edit, :students, :ideas, :update, :destroy]
  respond_to :html, :json
  autocomplete :institutions, :name, :full => true

  # GET /institutions
  # GET /institutions.json
  def index
    @institution = Institution.all
  end

  # GET /institutions/1
  # GET /institutions/1.json
  
  def show
  end

  def students
    @ideas = Idea.where(institution_id: @institution.id).limit(4)
    @students = User.where(institution_id: @institution.id).paginate(:page => params[:page], :per_page => 20)
    if request.xhr?
      render :partial=>"institutions/content/students"
    end
  end

  def ideas
    @entrepreneurs = User.where(institution_id: @institution.id).limit(4)
    @ideas = Idea.where(institution_id: @institution.id).paginate(:page => params[:page], :per_page => 20)
    if request.xhr?
      render :partial=>"institutions/content/ideas"
    end
  end

  # GET /institutions/new
  def new
    @institution = Institution.new
  end

  # GET /institutions/1/edit
  def edit
  end

  # POST /institutions
  # POST /institutions.json
  def create
    @institution = Institution.new(institutions_params)

    respond_to do |format|
      if @institution.save
        format.html { redirect_to @institution, notice: 'Institution was succesfully created.' }
        format.json { render :show, status: :created, location: @institution }
      else
        format.html { render :new }
        format.json { render json: @institution.errors, status: :unprocesable_entity }
      end
    end
  end

  # PATCH/PUT /institutions/1
  # PATCH/PUT /institutions/1.json
  def update
    respond_to do |format|
      if @institution.update(institutions_params)
        format.html { redirect_to @institutions, notice: 'Institution was succesfully updated.' }
        format.json { render :show, status: :ok, location: @institution }
      else
        format.html { render :edit }
        format.json { render json: @institution.errors, status: :unprocesable_entity }
      end
    end
  end

  # DELETE /institutions/1
  # DELETE /institutions/1.json
  def destroy
    @institution.destroy
    respond_to do |format|
      format.html { redirect_to institutions_url, notice: 'Institution was succesfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_institutions
      @user = current_user
      @institution = Organization.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def institutions_params
       params.require(:institution).permit(:id, :email, :name, :description, :website, :logo, :cover, :location, :established)
    end
end
