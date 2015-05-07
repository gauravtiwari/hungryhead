class CreateInvestmentService
  def initialize(params, user, idea)
    @params = params
    @user = user
    @idea = idea
  end

  def create
    @investment = Investment.new @params
    @investment.idea = @idea
    @investment.user = @user
    @investment
  end

end