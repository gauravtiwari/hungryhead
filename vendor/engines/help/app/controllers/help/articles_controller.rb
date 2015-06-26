require_dependency "help/application_controller"

module Help
  class ArticlesController < ApplicationController
    #Verify user access
    after_action :verify_authorized
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    def new
      @article = Article.new
      authorize @article
    end

    def create
      @article = Article.new(article_params)
      authorize @article
      if @article.save
        flash[:notice] = "Article Posted"
      else
        flash[:notice] = "Something with wrong #{@article.errors}"
      end
    end
    private

    def article_params
      params.require(:article).permit(:title, :body, :published, :category_id)
    end

  end
end
