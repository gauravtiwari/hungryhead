class IdeaSavedService

  include Rails.application.routes.url_helpers

  def initialize(idea)
    @idea = idea
  end

  def call
    load_into_soulmate
    expire_cache
  end

  private

  def expire_cache
    keys = [
      "popular_20_#{@idea.class.to_s.pluralize.downcase}",
      "latest_20_#{@idea.class.to_s.pluralize.downcase}",
      "trending_20_#{@idea.class.to_s.pluralize.downcase}"
    ]
    keys.each do |key|
      Rails.cache.delete(key)
    end
  end

  def load_into_soulmate
    if @idea.visible?
      loader = Soulmate::Loader.new("ideas")
      loader.add(
        "term" => @idea.name,
        "description" => @idea.high_concept_pitch,
        "id" => @idea.id,
        "data" => {
          "link" => idea_path(@idea)
        }
      )
    else
      remove_from_soulmate
    end
  end

end