class FeedbacksController < ApplicationController

  before_action :authenticate_user!
  before_action :set_feedback, only: [:rate, :show, :destroy]
  before_action :set_props, only: [:index, :show, :create, :rate]

  #Pundit authorization
  after_action :verify_authorized, :only => [:create, :destroy]
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  #set layout
  layout "idea"

  # GET /feedbacks
  # GET /feedbacks.json
  def index
    @team = User.fetch_multi(@idea.team_ids)
    @idea = Idea.fetch_by_slug(params[:idea_id])
    authorize @idea

    @feedbacks = @idea.get_published_feedbacks.paginate(:page => params[:page], :per_page => 20)
    respond_to do |format|
      format.js
      format.html
    end

  end

  # GET /feedbacks/1
  # GET /feedbacks/1.json
  def show
    @team = User.fetch_multi(@idea.team_ids)
    authorize @feedback.idea
    @feedbacks = @feedback.comment_threads.paginate(:page => params[:page], :per_page => 20)
  end

  # POST /feedbacks
  # POST /feedbacks.json
  def create
    @feedback = CreateFeedbackService.new(feedback_params, @idea, current_user).call
    authorize @feedback
    respond_to do |format|
      if @feedback.save
        format.json { render :show, status: :created}
      else
        format.json { render json: @feedback.errors,  status: :unprocessable_entity }
      end
    end
  end

  def rate
    @feedback.badged! if !@feedback.badged?
    @feedback.badge = params[:badge]
    @feedback.save
    render json: {
      rate: {
        record: @feedback.id,
        rated: @feedback.badged?,
        user_name: @idea.user.name,
        badge_name: @feedback.badge,
        rate_url: rate_idea_feedback_path(@feedback.idea.slug, @feedback.id)
      }
    }
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
      @feedback = Feedback.fetch_by_uuid(params[:id])
    end

    def set_props
      @idea = Idea.fetch_by_slug(params[:idea_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def feedback_params
      params.require(:feedback).permit(:body, :tag_list)
    end
end
