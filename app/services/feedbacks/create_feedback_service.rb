class CreateFeedbackService
  def initialize(params, idea, user)
    @params = params
    @idea = idea
    @user = user
  end

  def call
    feedback = @user.feedbacks.new @params
    feedback.idea = @idea
    feedback
  end
end
