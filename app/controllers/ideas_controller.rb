class IdeasController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_terms
  before_action :set_idea, only: [:card, :join_team, :feedbackers, :investors, :team, :comments, :show, :updates, :publish, :unpublish, :invite_team, :followers, :idea, :edit, :update, :destroy]
  before_action :set_user

  after_action :verify_authorized, except: [:index]
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  layout "idea"

  respond_to :json, :html

  # GET /ideas
  # GET /ideas.json
  def index
    @ideas = Idea.where(status: 1).order(id: :desc).paginate(:page => params[:page], :per_page => 10)
  end

  # GET /ideas/1
  # GET /ideas/1.json
  def show
  end

  def card
    render partial: 'shared/idea_card'
  end

  # PUT /ideas/1/unpublish
  def publish
    authorize @idea
    if @idea.profile_complete?
      @idea = PublishIdeaService.new(@idea, @user).publish
      render json: {is_public: true, msg: "Your idea profile was published successfully", profile_complete: @idea.profile_complete?, published: @idea.published?, url: unpublish_idea_path(@idea)}
    else
      render json: {msg: "We couldn't publish your idea profile as it's incomplete", profile_complete: @idea.profile_complete?, published: @idea.published?, url: publish_idea_path(@idea)}
    end
  end

  # PUT /ideas/1/unpublish
  def unpublish
    authorize @idea
    @idea.draft!
    @idea.me!
    UnpublishIdeaJob.perform_later(@idea)
    render json: {is_public: false, msg: "Your profile was unpublished successfully", profile_complete: @idea.profile_complete?, published: @idea.published?, url: publish_idea_path(@idea)}
  end

  # GET /ideas/1/updates
  def updates
    @versions = @idea.versions.reorder(created_at: :desc).paginate(:page => params[:page], :per_page => 10)
    if request.xhr?
      render :partial=>"ideas/_sub_pages/updates"
    end
  end

  # GET /ideas/1/comments
  def comments
    @comments = @idea.root_comments.reorder(id: :desc).paginate(:page => params[:page], :per_page => 10)
  end

  # GET /ideas/1/investors
  def investors
    @investors = @idea.find_investors.paginate(:page => params[:page], :per_page => 10)
    render 'investors/index'
  end

  # GET /ideas/1/feedbackers
  def feedbackers
    @feedbackers = @idea.find_feedbackers.paginate(:page => params[:page], :per_page => 10)
    render 'feedbackers/index'
  end

  # GET /ideas/1/followers
  def followers
    @followers = @idea.followers(User).paginate(:page => params[:page], :per_page => 10)
    render 'followers/index'
  end

  # GET /ideas/1/team
  def team
    @team = @idea.find_team
    render partial: 'ideas/_partials/team'
  end

  # POST /ideas/1/invite_team
  def invite_team
    params[:idea_invite][:invitees].split(", ").each do |id|
      user = User.find(id)
      InviteTeamJob.perform_later(@user, user, @idea, params[:idea_invite][:message])
    end
    render json: true
  end

  # GET /ideas/1/join_team
  def join_team
    JoinTeamJob.perform_later(@user, @idea.user.id, @idea)
    redirect_to idea_path(@idea), notice: "You have successfully joined #{@idea.name} team"
  end

  # GET /ideas/new
  def new
    @idea = Idea.new
    authorize @idea
  end

  # POST /ideas
  # POST /ideas.json
  def create
    @idea = Idea.new(idea_params)
    respond_to do |format|
      @idea.update_attributes(student_id: @user.id, school_id: @user.school_id)
      authorize @idea
      if @idea.save
          format.html { redirect_to @idea, notice: 'Idea was successfully created.' }
          format.json { render :show, status: :created, location: @idea }
      else
        format.html { render :new }
        format.json { render json: @idea.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ideas/1
  # PATCH/PUT /ideas/1.json
  def update
      authorize @idea
      if @idea.update(idea_params)
        team = @idea.team.join('')
        Pusher.trigger_async("presence-idea-collaboration-#{team}", "idea_update_#{@idea.id}", {id: @idea.id, data: render(template: 'ideas/update')}.to_json)
      else
        render json: @idea.errors, status: :unprocessable_entity
      end
  end

  # DELETE /ideas/1
  # DELETE /ideas/1.json
  def destroy
    @idea.destroy
    respond_to do |format|
      format.html { redirect_to ideas_url, notice: 'Idea was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = current_user
  end

  def set_idea
    @idea = Idea.find(params[:id])
    authorize @idea
  end

  # WhiteListed Params
  def idea_params
    params.require(:idea).permit(:looking_for_team, :video, :logo, :name, :high_concept_pitch,
      :elevator_pitch, :website, :location_list, :description, :cover, :market_list,
       :market, :problems, :technology_list, :solutions, :vision, :value_proposition)
  end

end
