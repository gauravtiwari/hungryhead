require_dependency "help/application_controller"

module Help
  class CategoriesController < ApplicationController
    before_action :set_category, only: [:show, :edit, :update, :destroy]

    # GET /categories
    def index
      if Category.count <= 0
        render :index
      else
        redirect_to help_category_path(Category.first)
      end
    end

    # GET /categories/1
    def show
      @categories = Category.all
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.friendly.find(params[:id])
    end

  end
end
