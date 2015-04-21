class PagesController < ApplicationController

  before_filter :check_terms
  layout "home"

  #Index page to handle home and after login route
  def index
    if user_signed_in?
      ids = current_user.followings_ids.members
      ids.push(current_user.id)
      @activities = PublicActivity::Activity
      .where(owner_id: ids, published: true)
      .where.not(key: 'follow.create')
      .order(id: :desc)
      .paginate(:page => params[:page], :per_page => 20)
      respond_to do |format|
        format.html
        format.js
      end
    else
      render 'pages/splash'
    end
  end

  #Our Story and how we got started
  def story
  end

  #Community rules
  def rules
  end

  #Terms and conditions
  def terms
  end

  #Privacy policy page
  def privacy
  end

  #Hello page - introduce ourselves

  def hello
  end

  #Getting started page for ideas
  def learn
  end

end
