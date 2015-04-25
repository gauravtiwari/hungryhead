class VotesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_votable, only: [:vote, :voters]

  def vote
    authorize @votable
    if @votable.voters_ids.members.include? current_user.id.to_s
      @vote = VoteService.new(current_user, @votable, profile_url(current_user)).unvote
    else
      @vote = VoteService.new(current_user, @votable, profile_url(current_user)).vote
    end
    voted = @votable.voters_ids.members.include? current_user.id.to_s
    render json: {
      voted: voted,
      url: vote_path(votable_type: @votable.class.to_s, votable_id: @votable.id),
      votes_count: @votable.votes_counter.value
    }
    expire_fragment("activities/activity-#{@votable.class.to_s}-#{@votable.id}-user-#{current_user.id}")
  end

  def voters
    @voters = @votable.votes_for.paginate(:page => params[:page], :per_page => 10)
    render 'voters/index'
  end

  def mentionables
    @mentionable = params[:mentionable_type].constantize.find(params[:id])
    if @mentionable.class.to_s == "Idea"
      mentionable = @mentionable.student
    else
      mentionable = @mentionable.user
    end
    @mentionables = Array.new
    @mentionables.push(name: mentionable.name, path: user_path(mentionable), username: mentionable.username) if mentionable != current_user
    @mentionable.comment_threads.includes(:user).map { |c| @mentionables.push({id: c.user.id, name: c.user.name, username: c.user.username, path: profile_url(c.user)}) unless @mentionables.include?({id: c.user.id, name: c.user.name, username: c.user.username, path: profile_url(c.user)}) && c.user == current_user }
    render json: @mentionables
  end

  private

  def load_votable
    @votables = ["Idea", "Feedback", "Investment", "Comment", "Share"]
    if @votables.include? params[:votable_type]
      @votable = params[:votable_type].safe_constantize.find(params[:votable_id])
    else
      respond_to do |format|
       format.html { render json: {error: 'Sorry, unable to vote on this entity'}, status: :unprocessable_entity }
      end
    end
  end
end
