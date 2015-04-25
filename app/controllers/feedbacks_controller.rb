class FeedbacksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_feedback, only: [:rate, :show, :edit, :update, :destroy]
  before_action :set_props, only: [:index, :show, :create]
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  layout "idea"

  # GET /feedbacks
  # GET /feedbacks.json
  def index
    @team = User.find(@idea.team)
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
    if @idea.can_feedback?(@user)
      respond_to do |format|
        if @feedback.save
          FeedbackNotificationService.new(@feedback).notify
          format.json { render :show, status: :created}
        else
          format.json { render json: @feedback.errors, status: :unprocessable_entity }
        end
      end
    else
      render json: {error: "Already feedbacked"}
    end
  end

  def rate
    @feedback.badged! if !@feedback.badged?
    @feedback.add_badge(params[:badge].to_i)
    msg = "<a href='#{user_url(@user)}'>You</a> have earned a badge for your <a href='#{idea_feedback_url(@feedback.idea, @feedback.id)}'>feedback</a>".html_safe
    AwardBadgeJob.set(wait: 10.seconds).perform_later(@user, @feedback.user, params[:badge].to_i, msg, "Feedback_#{@feedback.id}")
    @activity = Activity.find_by_trackable_id_and_trackable_type(@feedback.id, @feedback.class.to_s)
    render :rate, locals: {activity: @activity}
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
