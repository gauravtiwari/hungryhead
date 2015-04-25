class CreateFeedbackService

  def initialize(params, idea, user)
    @params = params
    @idea = idea
    @user = user
  end

  def create
    @feedback = Feedback.new @params
    @feedback.update_attributes(idea: @idea, user: @user)
    @feedback
  end

end