class PublishIdeaService

  def initialize(idea, user, privacy)
    @idea = idea
    @user = user
    @privacy = privacy
  end

  def publish_idea
    @idea.update_attributes(privacy: @privacy)
    @idea.published! unless @idea.published?
    @idea
  end

end