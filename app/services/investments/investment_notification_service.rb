class InvestmentNotificationService

  def initialize(investment)
    @investment = investment
    @idea = investment.idea
    @user = investment.user
  end

  def notify
    @activity = @user.activities.create!(trackable: @investment, verb: 'invested', recipient: @idea, key: 'investment.create')
    send_notification(@activity)
  end


  private

  def send_notification(activity)
    Pusher.trigger("private-user-#{@idea.student.id}",
      "new_feed_item",
      {data: activity.user.latest_activities.last}
    )
  end

end