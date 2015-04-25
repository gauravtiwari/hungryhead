class InvestmentNotificationService

  def initialize(investment)
    @investment = investment
    @idea = investment.idea
    @user = investment.user
  end

  def notify
    @activity = @user.activities.create!(trackable: @investment, verb: 'invested', recipient: @idea, key: 'create')
    send_notification(@activity)
  end


  private

  def send_notification(activity)
    Pusher.trigger("private-user-#{@idea.student.id}",
      "new_notification",
      {data:
        {
          id: activity.id,
          msg: ActivityPresenter.new(activity, self).render_activity
        }
      }.to_json
    )
  end

end