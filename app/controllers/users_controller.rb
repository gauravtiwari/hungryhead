class UsersController < ApplicationController
  before_filter :authenticate_user!, except: [:check_username, :check_email]
  before_filter :check_terms, except: [:update, :edit, :check_username, :check_email]
  before_action :set_user, except: [:tags, :autocomplete_user_name, :index, :check_username, :check_email]

  #Verify user access
  after_action :verify_authorized, :only => [:update, :edit]
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  layout "profile"
  autocomplete :user, :name, :full => true

  def index
    @users = User.where(state: 1).order(id: :desc).paginate(:page => params[:page], :per_page => 10)
    respond_to do |format|
      format.html
      format.json
    end
  end

  def edit
    authorize @user
  end

  def show
    @badges = @user.badges.group_by(&:id)
    @ideas = Idea.for_user(@user)
    respond_to do |format|
      format.html
    end
  end

  def card
    render partial: 'shared/user_card'
  end

  def user_invite
    params[:emails].split(", ").each do |email|
      @user = User.invite!({email: email}, current_user) do |u|
        u.skip_invitation = true
      end
      InviteMailer.invite_friends(@user, current_user).deliver
      @user.invitation_sent_at = Time.now.utc
    end
  end

  def update
    authorize @user
    respond_to do |format|
      if @user.update(user_params)
        if @user.username_changed?
          redirect_to user_profile_path(current_user)
        else
          format.html
          format.js
          format.json { render :show, status: :ok, location: @user }
        end
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def check_username
    user = User.where("username = ?", params[:username]).first
    if user.present?
      render :json =>  {
        error: "This Username is already taken. Please try another",
        available: false
      }
    else
      render :json =>  {error: "", available: true}
    end
  end

  def check_email
    user = User.where("email = ?", params[:email]).first
    if user.present?
      render :json =>  {
        name: user.name.split(' ').first,
        error: "This Email is already taken. Please login",
        available: false
      }
    else
      render :json =>  {error: "", available: true}
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
    end
  end

  def followers
    @followers = @user.followers_by_type('User')
    respond_to do |format|
      format.html
    end
  end

  def delete_cover
    @user.remove_cover!
    @user.save
    render 'users/delete_cover.json.jbuilder'
  end

  def followings
    @following = @user.following_by_type('User')
    respond_to do |format|
      format.html
    end
  end

  def activities
    @activities = PublicActivity::Activity
    .where(owner_id: @user.id, owner_type: "User")
    .order(created_at: :desc)
    .paginate(:page => params[:page], :per_page => 10)  
     respond_to do |format|
      format.html
      format.js
    end
  end

  def investments
    @investments = @user
    .investments
    .order(created_at: :desc)
    .paginate(:page => params[:page], :per_page => 10)
    if request.xhr?
      render :partial=>"users/_sub_pages/investments"
    end
  end

  def feedbacks
    @feedbacks = @user
    .feedbacks
    .order(created_at: :desc)
    .paginate(:page => params[:page], :per_page => 10)
    if request.xhr?
      render :partial=>"users/_sub_pages/feedbacks"
    end
  end

  private

  #Error message if user not authorised
  def user_not_authorized
    flash[:error] = "You are not authorized to perform this action."
    render json: {error: "You are not authorized to perform this action"}
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    id = params[:slug] || params[:id]
    @user = User.find(id)
  end

  # White-listed attributes.
  def user_params
    params.require(:user).permit(:name, :technology_list, :institution_id, :mini_bio, :service_list, :password, :avatar_crop_x, :avatar_crop_y, :avatar_crop_w, :avatar_crop_h,
      :email, :terms_accepted, :cover_position, :username, :reset_password_token, :password_confirmation,
      :name, :avatar, :subject_list, :cover, :about_me, :website_url, :google_plus_url, :facebook_url,
      :twitter_url, :linkedin_url, :location_list, :skill_list, :market_list, :mini_resume, :country)
  end

end
