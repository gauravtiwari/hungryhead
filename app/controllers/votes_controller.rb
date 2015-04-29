class VotesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_votable, only: [:vote, :voters]

  def vote
    authorize @votable
    @vote = CreateVoteService.new(current_user, @votable).create
    render json: {
      voted: @vote,
      url: vote_path(votable_type: @votable.class.to_s, votable_id: @votable.id),
      votes_count: @votable.votes_counter.value
    }
    expire_fragment("activities/activity-#{@votable.class.to_s}-#{@votable.id}-user-#{current_user.id}")
  end

  def voters
    @voters = @votable.votes_for.paginate(:page => params[:page], :per_page => 10)
    render 'voters/index'
  end

  private

  def load_votable
    @votables = ["Idea", "Feedback", "Investment", "Comment", "Share", "Note"]
    if @votables.include? params[:votable_type]
      @votable = params[:votable_type].safe_constantize.find(params[:votable_id])
    else
      respond_to do |format|
       format.html { render json: {error: 'Sorry, unable to vote on this entity'}, status: :unprocessable_entity }
      end
    end
  end
end
