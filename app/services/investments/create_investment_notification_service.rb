class CreateInvestmentNotificationService

  def initialize(investment)
    @investment = investment
    @idea = investment.idea
    @user = investment.user
  end

  def create
    @activity = @user.activities.create!(
      trackable: @investment,
      verb: 'invested',
      recipient: @idea,
      key: 'investment.create'
    )
    cache(@activity)
  end

  def cache(activity)
    CreateNotificationCacheService.new(activity).create
  end

end