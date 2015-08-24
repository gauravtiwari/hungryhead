class IdeaSavedService

  include Rails.application.routes.url_helpers

  def initialize(idea)
    @idea = idea
  end

  def call
    load_into_soulmate
  end

  private

  def load_into_soulmate
    if @idea.visible?
      loader = Soulmate::Loader.new("ideas")
      loader.add(
        "term" => @idea.name,
        "name_badge" => @idea.name_badge,
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

  def remove_from_soulmate
    loader = Soulmate::Loader.new("ideas")
    loader.remove("id" => @idea.id)
  end

end