class NewIdeaController < ApplicationController

  # Set before filter
  before_filter :authenticate_or_token!
  before_action :set_user

  # Set layout
  layout "new_idea"

  # Set steps using Wicked
  include Wicked::Wizard
  steps :intro, :pitch

  def show
    case step
    when :intro
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

  def create
    @idea = Idea.new(idea_params)
    @idea.update_attributes(user_id: @user.id, school_id: @user.school_id)
    if @idea.save
      render json: {status: :created, location_url: root_path,
        notice: "You have successfully pitched your idea."}
      #Track event into MixPanel
      meta_events_tracker.event!(:idea, :new_idea,
        {
          :name => @idea.name,
          user_name: @idea.user.name,
          :email => @idea.user.email
        })
    else
      render json: @idea.errors, status: :unprocessable_entity
    end
  end

  private

  def authenticate_or_token!
    return if user_signed_in? or params[:token].present?
    redirect_to root_path, alert: "You need to sign in or need unique link to pitch new idea."
  end

  def set_user
    if user_signed_in? && current_user
      @user = current_user
    elsif params[:token].present? and User.find_by_uid(params[:token]).present?
      @user = User.find_by_uid(params[:token])
      redirect_to root_path, alert: "Sorry! You have already posted 5 ideas." # TODO allow 5 ideas
    else
      redirect_to root_path, alert: "Ohh no.. you don't exist on our system! Please register with your email."
    end
  end

  def finish_wizard_path
    idea_path(@idea)
  end

  def idea_params
    params.require(:idea).permit(:rules_accepted, :name, :high_concept_pitch,
      :looking_for_team, :elevator_pitch, :location_list, :market_list)
  end
end