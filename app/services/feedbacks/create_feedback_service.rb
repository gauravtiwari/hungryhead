class CreateFeedbackService

  def initialize(params, idea, user)
    @params = params
    @idea = idea
    @user = user
  end

  def create
    @feedback = Feedback.new @params
    @feedback.idea = @idea
    @feedback.user = @user
    @feedback
  end

end