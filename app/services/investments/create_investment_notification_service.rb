class CreateInvestmentNotificationService

  def initialize(investment)
    @investment = investment
    @idea = investment.idea
    @user = investment.user
  end

  def create
    if @user.activities.where(trackable: @investment).empty?
      @activity = @user.activities.create!(
        trackable: @investment,
        verb: 'invested',
        recipient: @idea,
        key: 'investment.create',
        unread: true
      )
      cache(@activity)
    else
      return
    end
  end

  def cache(activity)
    CreateNotificationCacheService.new(activity).create
  end

end