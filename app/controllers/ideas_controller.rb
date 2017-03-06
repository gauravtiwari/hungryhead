class IdeasController < ApplicationController
  before_action :authenticate_user!
  before_action :check_terms
  before_action :set_idea, except: [:index, :featured, :latest, :popular, :trending, :create, :delete_cover]

  # Set layout
  layout 'idea'

  # GET /ideas
  # GET /ideas.json
  def index
    @ideas = Idea.includes(:school, :user)
                 .published.order(created_at: :desc)
                 .paginate(page: params[:page], per_page: 20)
  end

  # GET /ideas
  # GET /ideas.json
  def featured
    @ideas = Idea.includes(:school, :user)
                 .published.order(published_date: :desc)
                 .paginate(page: params[:page], per_page: 20)
    respond_to do |format|
      format.html { render :index }
    end
  end

  # GET /ideas/1
  # GET /ideas/1.json
  def show
    unless @idea.viewed?(current_user)
      PersistViewsCountJob.perform_later(
        current_user.id,
        @idea.id,
        @idea.class.to_s,
        request.referrer,
        request.remote_ip
      )
    end
  end

  # Get idea card
  # GET /idea/1/card
  def card
    render partial: 'shared/idea_card'
  end

  # Get latest ideas
  # GET /ideas/latest
  def latest
    respond_to do |format|
      format.html
      format.json do
        render json: Oj.dump({
                               list: Idea.latest_20,
                               type: 'Latest Ideas'
                             }, mode: :compat)
      end
    end
  end

  # GET popular ideas
  # GET /ideas/popular
  def popular
    @ideas = Idea.find(Idea.leaderboard.revrange(0, 20))
    respond_to do |format|
      format.html { render :index }
    end
  end

  # GET trending ideas
  # GET /ideas/trending
  def trending
    @ideas = Idea.find(Idea.trending.revrange(0, 20))
    respond_to do |format|
      format.html { render :index }
    end
  end

  # PUT /ideas/1/publish
  def publish
    if @idea.profile_complete?
      @idea.published!
      @idea.everyone!
      if @idea.published?
        CreateActivityJob.set(wait: 10.seconds).perform_later(@idea.id, @idea.class.to_s)
        @msg = "Your idea profile was successfully published to: #{@idea.privacy.capitalize}"
      else
        @msg = 'Something went wrong, please try again.'
      end
      render :publish
    else
      @msg = "Your idea profile isn't complete. Please complete profile and try again."
      render :publish
    end
  end

  # Delete cover
  def delete_cover
    @idea = Idea.find(params[:slug])
    @idea.remove_cover!
    @idea.save
    respond_to do |format|
      format.json { render :show, status: :ok }
    end
  end

  # GET /ideas/1/investors
  def investors
    @investors = @idea.find_investors.paginate(page: params[:page], per_page: 10)
    render 'investors/index'
  end

  # GET /ideas/1/feedbackers
  def feedbackers
    @feedbackers = @idea.find_feedbackers.paginate(page: params[:page], per_page: 10)
    render 'feedbackers/index'
  end

  # GET /ideas/1/voters
  def voters
    @votable = @idea
    @followers = @idea.get_voters.paginate(page: params[:page], per_page: 10)
    render 'voters/voters'
  end

  # GET /ideas/1/team
  def team
    @team = @idea.get_team.paginate(page: params[:page], per_page: 10)
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /ideas/1/changes
  def changes
    @versions = @idea.versions.reorder(id: :desc).paginate(page: params[:page], per_page: 10)
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /ideas
  # POST /ideas.json
  def create
    @idea = Idea.new(idea_params)
    @idea.update_attributes(user_id: current_user.id, school_id: current_user.school_id)
    authorize @idea
    if @idea.save
      render json: { status: :created, location_url: idea_path(@idea) }
    else
      render json: @idea.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /ideas/1
  # PATCH/PUT /ideas/1.json
  def update
    authorize @idea
    if @idea.update(idea_params)
      Pusher.trigger_async("presence-idea-collaboration-#{@idea.slug}",
                           "idea_update_#{@idea.slug}",
                           { id: @idea.uuid, data: render(template: 'ideas/show') }.to_json)
    else
      render json: @idea.errors, status: :unprocessable_entity
    end
  end

  # DELETE /ideas/1
  # DELETE /ideas/1.json
  def destroy
    authorize @idea
    SoftDeleteIdeaJob.perform_later(@idea)
    respond_to do |format|
      format.html { redirect_to ideas_url, notice: 'Idea was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Error message if user not authorised
  def idea_not_authorized
    if request.xhr?
      render json: { error: 'Not found' }, status: 404
    else
      raise ActionController::RoutingError, 'Not Found'
    end
  end

  def set_idea
    @idea = Idea.includes(:user).find(params[:id])
    @badges = @idea.badges.group_by(&:level)
    authorize @idea
  end

  # WhiteListed Params
  def idea_params
    params.require(:idea).permit(:looking_for_team, :rules_accepted, :video,
                                 :logo, :name, :high_concept_pitch, :elevator_pitch, :website,
                                 :location_list, :problems, :solutions, :market, :business_model,
                                 :value_propositions, :description, :cover, :cover_position,
                                 :cover_left, :market_list, :technology_list)
  end
end
