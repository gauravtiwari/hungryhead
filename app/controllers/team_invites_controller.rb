class TeamInvitesController < ApplicationController

  before_action :set_team_invite, only: :destroy
  before_action :authenticate_user

  #Pundit authorization
  after_action :verify_authorized
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def create
    invitees = []
    params[:team_invite][:invitees].split(", ").each do |user_id|
      user = User.find(user_id)
      invitees << user.name
      if @idea.in_team?(user) || @idea.invited?(user)
        render json: {error: 'Already in team'}, status: 200
      else
        @team_invite = CreateTeamInviteService.new(user, current_user, @idea, params[:idea_invite][:message] )
        @team_invite.authorize
        if @team_invite.save
          InviteTeamJob.perform_later(@team_invite.id)
        else
          render json: @team_invite.errors, status: :unprocessable_entity
        end
      end
    end
    render json: {success: "Successfully invited #{invitees.to_sentence}"}, status: 200
  end

  def update
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
