class TeamInvitesController < ApplicationController

  before_action :set_team_invite, only: [:destroy, :update]
  before_action :authenticate_user!

  #Pundit authorization
  after_action :verify_authorized
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def create
    @idea = Idea.friendly.find(params[:idea_id])
    invited = []
    params[:team_invite][:invitees].split(",").each do |user_id|
      user = User.find(user_id)
      if @idea.in_team?(user) || @idea.invited?(user)
        skip_authorization
      else
        @team_invite = CreateTeamInviteService.new(user, current_user, @idea, params[:team_invite][:message]).create
        authorize @team_invite
        if @team_invite.save
          invited << user.name
          #Send invitations to recipients
          InviteTeamJob.set(wait: 2.seconds).perform_later(@team_invite.id)
        else
          render json: @team_invite.errors, status: :unprocessable_entity
        end
      end
    end

    if @team_invite.errors.empty?
      render json: {success: "Successfully invited #{invited.to_sentence}"}, status: :created
    else
      render json: {
        invited: false,
        msg: "Something went wrong, please try again",
        status: :created
      }
    end
  end

  def update
    authorize @team_invite
    JoinTeamJob.perform_later(current_user, @idea.user.uid, @idea)
    redirect_to idea_path(@idea), notice: "You have successfully joined #{@idea.name} team"
  end

  def destroy
    @team_invite.destroy
    respond_to do |format|
      format.html { redirect_to ideas_url, notice: 'Idea was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_team_invite
    @team_invite = TeamInvite.find(params[:id])
  end

  def user_not_authorized
    render json: {error: "You are not authorised to perform this action"}, status: 404
  end

end
