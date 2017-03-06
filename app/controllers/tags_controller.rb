class TagsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :json

  layout 'home'

  def people
    if params[:tag].present?
      @tag = ActsAsTaggableOn::Tag.find_by_slug(params[:tag])
      @users = User.published.tagged_with(@tag.name)
                   .paginate(page: params[:page], per_page: 10)
    end
    respond_to do |format|
      format.html
      format.js { render 'users/index' }
    end
  end

  def show
    if params[:tag].present?
      @tag = ActsAsTaggableOn::Tag.find_by_slug(params[:tag])
      @ideas = Idea.published.tagged_with(@tag.name)
                   .paginate(page: params[:page], per_page: 2)
    end
    respond_to do |format|
      format.html
      format.js { render 'ideas/index' }
    end
  end
end
