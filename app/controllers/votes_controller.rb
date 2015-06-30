class VotesController < ApplicationController

  before_filter :authenticate_user!
  before_filter :load_votable, only: [:vote, :voters]

  def vote
    authorize @votable
    if @votable.voted?(current_user)
      CreateVoteService.new(current_user, @votable).unvote
      expire_fragment("activities/activity-#{@vote.votable_type}-#{@vote.votable_id}-user-#{current_user.id}")
    else
      @vote = CreateVoteService.new(current_user, @votable).vote
      if @vote.save
        render json: {
          voted: @votable.voted?(current_user),
          votes_count: @votable.votes_counter.value
        }
        CreateActivityJob.perform_later(@vote.id, @vote.class.to_s)
      else
        render json: @vote.errors, status: :unprocessable_entity
      end
    end
  end

  def voters
    @voters = User.fetch_multi(@votable.voters_ids.values).paginate(:page => params[:page], :per_page => 10)
    render 'voters/index'
  end

  private

  def load_votable
    @votables = ["Idea", "Feedback", "Investment", "Comment"]
    if @votables.include? params[:votable_type]
      if params[:votable_type] == "Comment"
        @votable = params[:votable_type].safe_constantize.fetch(params[:votable_id])
      else
        @votable = params[:votable_type].safe_constantize.fetch_by_uuid(params[:votable_id])
      end
    else
      respond_to do |format|
       format.html { render json: {error: 'Sorry, unable to vote on this entity'}, status: :unprocessable_entity }
      end
    end
  end
end
