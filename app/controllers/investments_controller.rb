class InvestmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_investment, only: [:show, :destroy]
  before_action :set_props, only: [:index, :show, :create]
  respond_to :json, :html

  layout "idea"

  # GET /investments
  # GET /investments.json
  def index
    @team  = User.find(@idea.team)
    current_user = current_user
    authorize @idea
    @investments = @idea
    .investments
    .order(id: :desc)
    .paginate(:page => params[:page], :per_page => 10)
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
    if current_user.balance_available?(params[:investment][:amount])
      @investment = CreateInvestmentService.new(investment_params, current_user, @idea).create
      authorize @investment
      respond_to do |format|
        if @investment.save
          UpdateBalanceService.new(@investment).invest
          format.json { render :show, status: :created}
          InvestmentNotificationService.new(@investment).notify
        else
          format.json { render json: @investment.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.json { render json: {error: "Insufficient Balance #{current_user.fund['balance']}"}, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_investment
      @idea = Idea.friendly.find(params[:idea_id])
      @investment = Investment.find(params[:id])
    end

    def set_props
      @idea = Idea.friendly.find(params[:idea_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def investment_params
      params.require(:investment).permit(:id, :amount, :note)
    end
end
