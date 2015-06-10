Help::Engine.routes.draw do

  root to: 'categories#index'
  resources :categories

  get '/:id', to: 'categories#show', as: :help_category

end
