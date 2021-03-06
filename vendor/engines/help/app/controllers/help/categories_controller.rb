require_dependency "help/application_controller"

module Help
  class CategoriesController < ApplicationController

    before_action :set_category, only: [:show, :edit, :update, :destroy]
    #Verify user access
    after_action :verify_authorized, :except => [:index, :show]
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    # GET /categories
    def index
      if Category.count <= 0
        render :index
      else
        redirect_to help_category_path(Category.first)
      end
    end

    def new
      @category = Category.new
      authorize @category
    end

    def edit
      @category = Category.friendly.find(params[:id])
      authorize @category
    end

    def update
      @category = Category.friendly.find(params[:id])
      authorize @category
      if @category.update(category_params)
        render :show
      end
    end

    def create
      @category = Category.new(category_params)
      authorize @category
      if @category.save
        flash[:notice] = "Category Created"
      else
        flash[:notice] = "Something with wrong #{@category.errors}"
      end
    end

    def destroy
      @category = Category.friendly.find(params[:id])
      authorize @category
      if @category.destroy
        flash[:notice] = "Article destroyed"
        respond_to do |format|
          format.js {render :destroy}
        end
      end
    end

    # GET /categories/1
    def show
      @categories = Category.order(id: :asc)
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.includes(:articles).friendly.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name, :description)
    end

  end
end
