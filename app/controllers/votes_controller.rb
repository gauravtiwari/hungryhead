class VotesController < ApplicationController
  before_filter :authenticate_user!
  before_action :load_votable

  def vote
    return render_data if @votable.voted?(current_user)
    @vote = CreateVoteService.new(current_user, @votable).vote
    authorize @vote
    if @vote.save
      render_data
    else
      render json: @vote.errors, status: :unprocessable_entity
    end
  end

  def unvote
    return render_data unless @votable.voted?(current_user)
    @vote = CreateVoteService.new(current_user, @votable).unvote
    authorize @vote
    if @vote.destroy
      render_data
    else
      render json: @vote.errors, status: :unprocessable_entity
    end
  end

  def voters
    @voters = User.find(@votable.voters_ids.values)
                  .paginate(page: params[:page], per_page: 20)
    render 'voters/index'
  end

  private

  def render_data
    render json: {
      vote: @votable.voted?(current_user),
      votes_count: @votable.votes_counter.value,
      voter: current_user.card_json
    }
  end

  def load_votable
    @votables = %w(Idea Feedback Investment Comment)
    if @votables.include? params[:votable_type]
      @votable = params[:votable_type].constantize.find_by_uuid(params[:votable_id])
    else
      respond_to do |format|
        format.html do
          render json: { error: 'Sorry, unable to vote on this entity' },
                 status: :unprocessable_entity
        end
      end
    end
  end
end
