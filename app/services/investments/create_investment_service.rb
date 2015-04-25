class CreateInvestmentService
  def initialize(params, user, idea)
    @params = params
    @user = user
    @idea = idea
  end

  def create
    @investment = Investment.new @params
    @investment.update_attributes(idea_id: @idea.id, user_id: @user.id)
    @investment
  end

end