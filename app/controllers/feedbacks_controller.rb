class FeedbacksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_feedback, only: [:rate, :show, :edit, :update, :destroy]
  before_action :set_props, only: [:index, :show, :create]
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  layout "idea"

  # GET /feedbacks
  # GET /feedbacks.json
  def index
    @team = User.find(@idea.team_ids)
    authorize @idea
    @feedbacks = @idea.feedbacks
    .order(id: :desc)
    .paginate(:page => params[:page], :per_page => 20)
  end

  # GET /feedbacks/1
  # GET /feedbacks/1.json
  def show
    @team = User.find(@idea.team)
    authorize @feedback.idea
    if @feedback
      @comments = @feedback.comment_threads.paginate(:page => params[:page], :per_page => 20)
    end
  end

  # GET /feedbacks/1/edit
  def edit
  end

  # POST /feedbacks
  # POST /feedbacks.json
  def create
    @feedback = CreateFeedbackService.new(feedback_params, @idea, current_user).create
    authorize @feedback
    respond_to do |format|
      if @feedback.save
        format.json { render :show, status: :created}
      else
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  def rate
    feedback_badges = [15, 16, 17, 18, 19]
    if feedback_badges.include?(params[:badge].to_i)
      @feedback.badged! if !@feedback.badged?
      @feedback.add_badge(params[:badge].to_i)
      AwardBadgeJob.set(wait: 10.seconds).perform_later(@feedback.user.id, params[:badge].to_i, "Feedback_#{@feedback.id}")
      @activity = Activity.find_by_trackable_id_and_trackable_type(@feedback.id, @feedback.class.to_s)
      render :rate, locals: {activity: @activity}
    else
      render json: {error: "Badge does not exist for this entity", status: :unprocessable_entity }
    end
  end

  # PATCH/PUT /feedbacks/1
  # PATCH/PUT /feedbacks/1.json
  def update
    authorize @feedback
    respond_to do |format|
      if @feedback.update(feedback_params)
        format.html { redirect_to @feedback, notice: 'Feedback was successfully updated.' }
        format.json { render :show, status: :ok, location: @feedback }
      else
        format.html { render :edit }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /feedbacks/1
  # DELETE /feedbacks/1.json
  def destroy
    authorize @feedback
    @feedback.idea.feedbackers.delete(@feedback.user.id.to_s)
    @feedback.idea.save!
    DestroyRecordJob.perform_later(@feedback)
    render json: {message: "Feedback deleted", deleted: true}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feedback
      @feedback = Feedback.find(params[:id])
      @user = current_user
    end

    def set_props
      @idea = Idea.friendly.find(params[:idea_id])
      @user = current_user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def feedback_params
      params.require(:feedback).permit(:id, :tag_list, :cached_tag_list, :idea_type, :idea_id, :is_response, :body, :user_id, :parent_id, :lft, :rgt, :status, :sash_id, :level)
    end
end
