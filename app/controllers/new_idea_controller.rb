class NewIdeaController < ApplicationController
  layout "new_idea"

  include Wicked::Wizard
  steps :rules, :pitch

  def show
    case step
    when :rules
      @idea = Idea.new
      session[:idea] = nil
    else
      @idea = Idea.new(session[:idea])
    end
    render_wizard
  end

  def update
    render_wizard
  end

  private

  def finish_wizard_path
    idea_path(@idea)
  end

  def idea_params
    params.require(:idea).permit(:rules_accepted, :name, :high_concept_pitch,
      :looking_for_team, :elevator_pitch, :location_list, :market_list)
  end
end