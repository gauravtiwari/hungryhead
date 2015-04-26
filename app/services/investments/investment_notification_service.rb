class InvestmentNotificationService

  def initialize(investment)
    @investment = investment
    @idea = investment.idea
    @user = investment.user
  end

  def notify
    @activity = @user.activities.create!(trackable: @investment, verb: 'invested', recipient: @idea, key: 'investment.create')
  end

end