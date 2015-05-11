class CreateFeedbackService

  def initialize(params, idea, user)
    @params = params
    @idea = idea
    @user = user
  end

  def call
    feedback = @user.feedbacks.new @params
    feedback.idea = @idea

    if feedback.valid?
      publish :new_feedback, feedback
    else
      publish :feedback_validation_error, feedback
    end
  end

end