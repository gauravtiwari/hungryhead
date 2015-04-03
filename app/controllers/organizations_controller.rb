class OrganizationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_terms
  before_action :set_organization, only: [:notifications, :show, :activities, :edit, :students, :ideas, :update, :destroy]
  respond_to :html, :json
  autocomplete :organization, :name, :full => true

  # GET /organizations
  # GET /organizations.json
  def index
    @organizations = Organization.all
  end

  # GET /organizations/1
  # GET /organizations/1.json

  def show
    @users = User.where(institution_id: @organization.id)
    if !request.xhr?
      @students = @users
      @ideas = @organization.ideas
      @entrepreneurs = @users.entrepreneurs
      @user = current_user
    end
    student_ids =  @users.map(&:id)
    @activities = PublicActivity::Activity
    .where(owner_id: student_ids, owner_type: "User", published: true)
    .order(id: :desc)
    .paginate(:page => params[:page], :per_page => 20)

    if request.xhr?
      respond_to do |format|
        format.js
      end
    else
      respond_to do |format|
        format.html
      end
    end

  end

  def students
    @ideas = Idea.where(organization_id: @organization.id).limit(4)
    @students = User.where(organization_id: @organization.id).paginate(:page => params[:page], :per_page => 20)
    if request.xhr?
      render :partial=>"organizations/content/students"
    end
  end

  def ideas
    @entrepreneurs = User.where(organization_id: @organization.id).limit(4)
    @ideas = Idea.where(organization_id: @organization.id).paginate(:page => params[:page], :per_page => 20)
    if request.xhr?
      render :partial=>"organizations/content/ideas"
    end
  end

  # GET /organizations/new
  def new
    @organization = Organization.new
  end

  # GET /organizations/1/edit
  def edit
  end

  # POST /organizations
  # POST /organizations.json
  def create
    @organization = Organization.new(organization_params)
    respond_to do |format|
      if @organization.save
        format.html { redirect_to @organization, notice: 'Organization was successfully created.' }
        format.json { render :show, status: :created, location: @organization }
      else
        format.html { render :new }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /organizations/1
  # PATCH/PUT /organizations/1.json
  def update
    respond_to do |format|
      if @organization.update(organization_params)
        format.html { redirect_to @organization, notice: 'Organization was successfully updated.' }
        format.json { render :show, status: :ok, location: @organization }
      else
        format.html { render :edit }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /organizations/1
  # DELETE /organizations/1.json
  def destroy
    @organization.destroy
    respond_to do |format|
      format.html { redirect_to organizations_url, notice: 'Organization was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organization
      @user = current_user
      id = params[:slug] || params[:id]
      @organization = Organization.find(id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def organization_params
       params.require(:organization).permit(:id, :name, :description, :location, :cover_position,
        :logo, :cover, :website, :established)
    end
end
