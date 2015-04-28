class NewIdeaController < ApplicationController
  include Wicked::Wizard
  steps :rules, :create

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
    case step
    when :rules
      @idea = Idea.new(idea_params)
      session[:idea] = @idea.attributes
      render_wizard
    when :create
      session[:idea] = session[:idea].merge(params[:idea])
      @idea = Idea.new(session[:idea])
      @idea.save
      redirect_to idea_path(@idea)
    end
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