class InvestmentNotificationService

  def initialize(investment)
    @investment = investment
    @idea = investment.idea
    @user = investment.user
  end

  def notify
    @activity = @user.activities.create!(trackable: @investment, verb: 'invested', recipient: @idea, key: 'investment.create')
    InvestmentNotificationCacheService.new(@activity).cache
    send_notification(@activity)
  end

  private

  def send_notification(activity)
    Pusher.trigger_async("private-user-#{@idea.student.id}",
      "new_feed_item",
      {
        data:  activity.user.latest_notifications.members.first
      }.to_json
    )
    idea_notification(activity)
  end

  def idea_notification(activity)
    if @activity.recipient_type == "Idea"
      Pusher.trigger_async("idea-feed-#{activity.recipient_id}",
        "new_feed_item",
        {
          data: activity.recipient.latest_notifications.members.first
        }.to_json
      )
    end
  end

end