class UsersController < ApplicationController
  before_filter :authenticate_user!, except: [:check_username, :check_email, :join]
  before_filter :check_terms, except: [:update, :edit, :check_username, :check_email, :join]
  before_action :set_user, except: [:latest, :popular, :trending, :tags, :autocomplete_user_name, :join, :index, :check_username, :check_email]

  #Verify user access
  after_action :verify_authorized, :only => [:update, :edit]
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  layout "home"
  autocomplete :user, :name, :full => true

  def index
    @users = User.order(id: :desc).paginate(:page => params[:page], :per_page => 12)
    respond_to do |format|
      format.html
      format.json
    end
  end

  def latest
    render json: Oj.dump({
      list: User.latest.values,
      type: 'Latest People'
      }, mode: :compat)
  end

  def popular
    @users = User.popular_20.paginate(:page => params[:page], :per_page => 20)
    render json: Oj.dump({
      list: @users,
      type: 'Popular People',
      next_page: @users.next_page
      }, mode: :compat)
  end

  def trending
    @users = User.trending_20.paginate(:page => params[:page], :per_page => 20)
    render json: Oj.dump({
      list: @users,
      type: 'Trending People',
      next_page: @users.next_page
      }, mode: :compat)
  end

  def edit
    authorize @user
  end

  def show
    User.trending.increment(@user.id) if @user != current_user
    respond_to do |format|
      format.html {render :show} if @user.type == "User"
      format.html {render :show} if @user.type == "Student"
      format.html {render :mentor} if @user.type == "Mentor"
      format.html {render :teacher} if @user.type == "Teacher"
    end
  end

  def card
    render partial: 'shared/user_card'
  end

  def user_invite
    users = params[:user][:name].zip(params[:user][:email])
    invited = []
    users.each do |u|
      @user = User.invite!({name: u[0], email: u[1]}, current_user) do |u|
        u.skip_invitation = true
      end
      InviteMailer.invite_friends(@user, current_user).deliver
      @user.invitation_sent_at = Time.now.utc
      invited << u[0] if u[0].present?
    end
    render json: {invited: true, msg: "You have succesfully invited #{invited.to_sentence}", status: :created}
  end

  def update
    authorize @user
    respond_to do |format|
      if @user.update(user_params)
        if @user.username_changed?
          redirect_to profile_path(@user)
        else
          format.html { redirect_to profile_path(@user), notice: 'Preferences was succesfully updated.' }
          format.json { render :show, status: :ok }
        end
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def check_username
    user = User.where("username = ?", params[:username]).first
    @user = User.new(username: params[:username], name: params[:name])
    if user.present?
      render :json =>  {
        error: "This Username is already taken. Please try followings \n",
        suggestions: @user.username_suggestions.to_sentence,
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

  def followers
    @followers = @user.followers_by_type('User')
    respond_to do |format|
      format.html
    end
  end

  def delete_cover
    @user.remove_cover!
    @user.save
    respond_to do |format|
      format.html
      format.json { render :show, status: :ok }
    end
  end

  def followings
    @following = @user.following_by_type('User')
    respond_to do |format|
      format.html
    end
  end

  def activities
    @activities = Activity
    .where(user_id: @user.id)
    .order(created_at: :desc)
    .paginate(:page => params[:page], :per_page => 10)
     respond_to do |format|
      format.html
      format.js
    end
  end

  def notes
    @notes = @user
    .notes
    .order(created_at: :desc)
    .paginate(:page => params[:page], :per_page => 10)
    if request.xhr?
      render :partial=>"users/_sub_pages/notes"
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
    @badges = @user.badges.group_by(&:id)
  end

  # White-listed attributes.
  def user_params
    params.require(:user).permit(:name, :mini_bio, :password, :avatar_crop_x, :avatar_crop_y, :avatar_crop_w, :avatar_crop_h,
      :email, :terms_accepted, :cover_position, :cover_left, :username, :reset_password_token, :password_confirmation,
      :name, :avatar, :subject_list, :cover, :about_me, :website_url, :facebook_url,
      :twitter_url, :linkedin_url, :location_list, :hobby_list, :market_list, :idea_notifications,
      :investment_notifications, :feedback_notifications, :follow_notifications, :weekly_mail)
  end

end
