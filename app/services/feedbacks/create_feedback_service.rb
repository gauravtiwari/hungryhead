class CreateFeedbackService

  def initialize(params, idea, user)
    @params = params
    @idea = idea
    @user = user
  end

  def create
    @feedback = Feedback.new @params
    @feedback.user = @user
    @feedback.idea = @idea
    @feedback
  end

end