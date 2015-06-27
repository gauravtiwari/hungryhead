class PublishIdeaService

  include Wisper::Publisher

  def initialize(idea, user, privacy)
    @idea = idea
    @user = user
    @privacy = privacy
  end

  def publish_idea
    if @idea.profile_complete?
      @idea.update_attributes(privacy: @privacy)
      @idea.published! unless @idea.published?
      publish :idea_published, @idea
    else
      publish :error, @idea
    end
  end

end