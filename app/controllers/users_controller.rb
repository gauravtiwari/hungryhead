class UsersController < ApplicationController
  before_filter :authenticate_user!, except: [:check_username, :check_email, :join]
  before_filter :check_terms, except: [:update, :edit, :check_username, :check_email, :join]
  before_action :set_user, except: [:latest, :popular, :people_you_may_know, :trending, :tags, :autocomplete_user_name, :join, :index, :check_username, :check_email]

  layout 'home'

  autocomplete :user, :name, full: true, extra_data: [:username]

  def index
    types = %w(student alumni faculty)
    @users = if params[:type].present? && types.include?(params[:type])
               User.send(params[:type]).published
                   .order(id: :desc)
                   .paginate(page: params[:page], per_page: 20)
             else
               User.published.order(id: :desc)
                   .paginate(page: params[:page], per_page: 20)
             end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def latest
    respond_to do |format|
      format.html
      format.json do
        render json: Oj.dump({
                               list: User.latest_20,
                               type: 'Latest People'
                             }, mode: :compat)
      end
    end
  end

  def popular
    respond_to do |format|
      format.html
      format.json do
        render json: Oj.dump({
                               list: User.popular_20,
                               type: 'Popular People'
                             }, mode: :compat)
      end
    end
  end

  def trending
    respond_to do |format|
      format.html
      format.json do
        render json: Oj.dump({
                               list: User.trending_20,
                               type: 'Trending People'
                             }, mode: :compat)
      end
    end
  end

  def edit
    authorize @user
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    authorize @user
    if !@user.impressioners_ids.member?(current_user.id) && @user != current_user
      PersistViewsCountJob.perform_later(current_user.id, @user.id, @user.class.to_s, request.referrer, request.remote_ip)
    end
    respond_to do |format|
      format.html
      format.json
    end
  end

  def card
    authorize @user
    render partial: 'shared/user_card'
  end

  def user_invite
    users = params[:user][:name].zip(params[:user][:email])
    invited = []
    users.delete(['', ''])
    users.each do |u|
      @user = User.invite!({ name: u[0], email: u[1] }, current_user) do |u|
        u.skip_invitation = true
      end
      @user.invitation_sent_at = Time.now.utc
      InviteMailer.invite_friends(@user, current_user).deliver if @user.errors.empty?
      invited << u[0] if u[0].present?
    end

    if @user.errors.empty?
      render json: {
        invited: true,
        msg: "You have succesfully invited #{invited.to_sentence}",
        status: :created
      }
    else
      render json: {
        invited: false,
        msg: 'Something went wrong, please try again',
        status: :created
      }
    end
  end

  def about_me
    authorize @user
  end

  def update
    authorize @user
    respond_to do |format|
      if @user.update(user_params)
        if @user.username_changed?
          redirect_to profile_path(@user)
        else
          format.html { redirect_to profile_path(@user), notice: 'Profile was succesfully updated.' }
          format.js { render :show, flash: { notice: 'Your profile was succesfully updated.' } }
          format.json { render :show, status: :ok }
        end
      else
        format.html { render :update }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def check_username
    user = User.where('username = ?', params[:username]).first
    @user = User.new(username: params[:username], name: params[:name])
    if user.present?
      render json: {
        error: "This Username is already taken. Please try followings \n",
        suggestions: @user.username_suggestions.to_sentence,
        suggested: @user.username_suggestions.second,
        available: false
      }
    else
      render json: { error: '', available: true }
    end
  end

  def check_email
    user = User.where('email = ?', params[:email]).first
    if user.present?
      render json: {
        name: user.name.split(' ').first,
        error: 'You email is already registered. Please login',
        available: false
      }
    else
      render json: { error: '', available: true }
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

  def people_you_may_know
    @users = User.find(current_user.people_you_may_know)
                 .paginate(page: params[:page], per_page: 9)
    respond_to do |format|
      format.json { render :index }
    end
  end

  def activities
    authorize @user
    @activities = @user.activities
                       .order(created_at: :desc)
                       .paginate(page: params[:page], per_page: 10)
    @next_page_url = profile_activities_path(page: @activities.next_page)
    respond_to do |format|
      format.js { render 'activities/index' }
      format.html
    end
  end

  def activity
    authorize @user
    @activity = @user.activities.find(params[:id])
    respond_to do |format|
      format.js
      format.html
    end
  end

  private

  # Error message if user not authorised
  def user_not_authorized
    if request.xhr?
      render json: { error: 'Not found' }, status: 404
    else
      raise ActionController::RoutingError, 'Not Found'
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    id = params[:slug] || params[:id]
    @user = User.find(id)
    @badges = @user.badges.group_by(&:level)
  end

  # White-listed attributes.
  def user_params
    params.require(:user).permit(:name, :mini_bio, :password,
                                 :email, :terms_accepted, :first_name, :last_name, :school_id,
                                 :feed_preferences, :cover_position, :cover_left, :username,
                                 :reset_password_token, :password_confirmation, :name, :avatar,
                                 :cover, :about_me, :website_url, :facebook_url, :role, :twitter_url,
                                 :linkedin_url, :location_list, :hobby_list, :subject_list, :skill_list,
                                 :market_list, :idea_notifications, :investment_notifications,
                                 :feedback_notifications, :follow_notifications, :weekly_mail)
  end
end
