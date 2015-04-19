class PagesController < ApplicationController

  before_filter :check_terms

  layout "home"

  def index
    if user_signed_in?
      ids = current_user.following_by_type('User').map(&:id)
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

 def story

 end
 def learn

 end

  def about
  end


end
