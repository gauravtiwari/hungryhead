class InvestmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_investment, only: [:show, :destroy]
  before_action :set_props, only: [:index, :show, :create]
  after_action :verify_authorized, :only => [:index, :create, :show]
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  respond_to :json, :html

  layout "idea"

  # GET /investments
  # GET /investments.json
  def index
    @team  = User.find(@idea.team)
    @user = current_user
    authorize @idea
    @investments = @idea
    .investments
    .order(id: :desc)
    .paginate(:page => params[:page], :per_page => 10)
    @team = User.find(@idea.team)
  end

  # GET /investments/1
  # GET /investments/1.json
  def show
    @team  = User.find(@idea.team)
    authorize @idea
  end

  # POST /investments
  # POST /investments.json
  def create
    if @user.balance_available?(params[:investment][:amount])
      @investment = MakeInvestmentService.new(investment_params, @user, @idea).create
      authorize @investment
      object_url = idea_investment_url(@investment.idea, @investment.id)
      idea_url = idea_url(@investment.idea)
      user_url = profile_url(@user)

      respond_to do |format|
        if @investment.save
          @investment = UpdateBalanceService.new(@investment, @user, @idea).invest
          PostInvestmentJob.perform_later(@investment, @user, object_url, idea_url, user_url)
          format.json { render :show, status: :created}
        else
          format.json { render json: @investment.errors, status: :unprocessable_entity }
        end
      end
    else 
      render json: {error: "Insufficient Balance #{@user.fund['balance']}"}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_investment
      @idea = Idea.friendly.find(params[:idea_id])
      @team = User.find(@idea.team)
      @user = current_user
      @investment = Investment.find(params[:id])
    end

    def set_props
      @idea = Idea.friendly.find(params[:idea_id])
      @user = current_user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def investment_params
      params.require(:investment).permit(:id, :amount, :note)
    end
end
