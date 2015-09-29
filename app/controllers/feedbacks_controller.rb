class FeedbacksController < ApplicationController

  before_action :authenticate_user!
  before_action :set_feedback, only: [:rate, :show, :destroy]
  before_action :set_props, only: [:index, :show, :create, :rate]

  #set layout
  layout "idea"

  # GET /feedbacks
  # GET /feedbacks.json
  def index
    @team = User.find(@idea.team_ids)
    @idea = Idea.find(params[:idea_id])
    authorize @idea

    @feedbacks = @idea.get_published_feedbacks.paginate(:page => params[:page], :per_page => 10)
    respond_to do |format|
      format.js
      format.html
    end

  end

  # GET /feedbacks/1
  # GET /feedbacks/1.json
  def show
    @team = User.find(@idea.team_ids)
    authorize @feedback.idea
    @feedbacks = @feedback.root_comments.paginate(:page => params[:page], :per_page => 10)
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
    if @feedback.save
      render json: {
        rate: {
          record: @feedback.id,
          rated: @feedback.badged?,
          user_name: @idea.user.name,
          badge_name: @feedback.badge,
          rate_url: rate_idea_feedback_path(@feedback.idea.slug, @feedback.id)
        }
      }
      RateFeedbackNotificationService.new(current_user, @feedback).create
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
    @feedback = Feedback.find_by_uuid(params[:id])
  end

  def set_props
    @idea = Idea.find(params[:idea_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def feedback_params
    params.require(:feedback).permit(:body, :tag_list)
  end
end
