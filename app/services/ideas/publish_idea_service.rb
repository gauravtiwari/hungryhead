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
      cache_viewers
      publish :idea_published, @idea
    else
      publish :error, @idea
    end
  end

  def cache_viewers
    if @idea.school?
      User.where(school_id: @idea.user.school_id).find_each do |u|
        @idea.viewers_ids << u.id
      end
    elsif @idea.friends?
      @idea.user.friends.find_each do |u|
        @idea.viewers_ids << u.id
      end
    end
  end

end