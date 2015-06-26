Help::Engine.routes.draw do

  root to: 'categories#index'
  resources :categories
  resources :articles, except: :show

  get '/:id', to: 'categories#show', as: :help_category

end
