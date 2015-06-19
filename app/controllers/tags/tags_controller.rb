class TagsController < ApplicationController
	before_filter :authenticate_user!
	respond_to :html, :json

	layout "home"

	def people
		if params[:tag].present?
		  @tag = ActsAsTaggableOn::Tag.find_by_slug(params[:tag])
		  @users = User.tagged_with(@tag.name)
		  .paginate(:page => params[:page], :per_page => 10)
		end
		render 'tags/people'
	end

	def show
		if params[:tag].present?
		  @tag = ActsAsTaggableOn::Tag.find_by_slug(params[:tag])
		  @ideas = Idea.tagged_with(@tag.name)
		  .paginate(:page => params[:page], :per_page => 10)
		end
		render 'tags/index'
	end

end
