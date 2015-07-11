require_dependency "site_feedback/application_controller"

module SiteFeedback
  class FeedbacksController < ApplicationController
    before_action :set_feedback, only: [:show, :edit, :update, :destroy]

    # GET /feedbacks
    def index
      @feedback = SiteFeedback::Feedback.new
    end

    # GET /feedbacks/1
    def show
    end

    # GET /feedbacks/new
    def new
      @feedback = SiteFeedback::Feedback.new
    end

    # POST /feedbacks
    def create
      @feedback = SiteFeedback::Feedback.new(feedback_params)
      @feedback.request = request
      @feedback.user = current_user if current_user
      if @feedback.save
        respond_to do |format|
          format.js {render :show, notice: 'Thank you so much for your time. We have recieved your feedback.'}
        end
      else
        format.js {render :new, error: 'Something went wrong'}
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_feedback
        @feedback = SiteFeedback::Feedback.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def feedback_params
        params.require(:feedback).permit(:name, :email, :body)
      end
  end
end
