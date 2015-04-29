class InvestmentNotificationService

  def initialize(investment)
    @investment = investment
    @idea = investment.idea
    @user = investment.user
  end

  def notify
    @activity = @user.activities.create!(trackable: @investment, verb: 'invested in', recipient: @idea, key: 'investment.create')
    send_notification(@activity)
  end


  private

  def send_notification(activity)
    Pusher.trigger("private-user-#{@idea.student.id}",
      "new_feed_item",
      {
        data: activity
      }.to_json
    )
    if @activity.recipient_type == "Idea"
      Pusher.trigger_async("idea-feed-#{activity.recipient_id}",
        "new_feed_item",
        {
          data: activity
        }.to_json
      )
    end
  end

end