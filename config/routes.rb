Rails.application.routes.draw do

  resources :teachers
  resources :students
  resources :mentors
  root 'pages#index'

  mount Soulmate::Server, :at => "/search"

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  post "pusher/auth"

  get '/learn-more', to: 'pages#learn_more', as: :learn_more

  #Pages routes
  resources :pages do
    member do
      get 'about'
    end
  end

  resources :after_signup

  # Authentication
  devise_for :users, skip: [:sessions, :passwords, :confirmations, :registrations],  controllers: {sessions: 'users/sessions',  invitations: "users/invitations", registrations: 'users/registrations', :confirmations => "users/confirmations"}
  as :user do
    # session handling
    get     '/login'  => 'users/sessions#new',     as: 'new_user_session'
    post    '/login'  => 'users/sessions#create',  as: 'user_session'
    get  '/logout' => 'users/sessions#destroy', as: 'destroy_user_session'

    # joining
    get   '/join' => 'users/registrations#new',    as: 'new_user_registration'
    post  '/join' => 'users/registrations#create', as: 'user_registration'
    put  '/join' => 'users/registrations#update', as: 'user_update'
    delete  '/join' => 'devise/registrations#destroy', as: 'user_delete'

    scope '/account' do
      # password reset
      get   '/reset-password'        => 'users/passwords#new',    as: 'new_user_password'
      put   '/reset-password'        => 'devise/passwords#update', as: 'user_password'
      post  '/reset-password'        => 'devise/passwords#create'
      get   '/reset-password/change' => 'users/passwords#edit',   as: 'edit_user_password'

      # confirmation
      get   '/confirm'        => 'users/confirmations#show',   as: 'user_confirmation'
      post  '/confirm'        => 'devise/confirmations#create'
      get   '/confirm/resend' => 'users/confirmations#new',    as: 'new_user_confirmation'

      # settings & cancellation
      get '/cancel'   => 'users/registrations#cancel', as: 'cancel_user_registration'
      get '/settings' => 'users/registrations#edit',   as: 'edit_user_registration'
      put '/settings' => 'users/registrations#update', as: 'update_user_registeration'

      # account deletion
      delete '' => 'devise/registrations#destroy'
    end
  end

  devise_for :mentors, skip: [:sessions, :passwords, :confirmations, :registrations], controllers: {sessions: 'users/sessions',  invitations: "users/invitations", :confirmations => "users/confirmations", registrations: 'mentors/registrations'} 
  as :mentor do
    # mentor joining
    get   '/mentors/join' => 'mentors/registrations#new',    as: 'new_mentor_registration'
    post  '/mentors/join' => 'mentors/registrations#create', as: 'mentor_registration'
    put  '/mentors/join' => 'mentors/registrations#update', as: 'mentor_update'
    delete  '/mentors/join' => 'devise/registrations#destroy', as: 'mentor_delete'
  end

  devise_for :teachers, skip: [:sessions, :passwords, :confirmations, :registrations], controllers: {sessions: 'users/sessions',  invitations: "users/invitations", :confirmations => "users/confirmations", registrations: 'teachers/registrations'}
  as :teacher do
    # teacher joining
    get   '/teachers/join' => 'teachers/registrations#new',    as: 'new_teacher_registration'
    post  '/teachers/join' => 'teachers/registrations#create', as: 'teacher_registration'
    put  '/teachers/join' => 'teachers/registrations#update', as: 'teacher_update'
    delete  '/teachers/join' => 'devise/registrations#destroy', as: 'teacher_delete'
  end

  match '/like',  to: 'likes#like', via: :put, as: 'like'
  match '/likers', to: 'likes#likers', via: :get, as: 'likers'
  match '/sharers', to: 'shares#sharers', via: :get, as: 'sharers'
  match '/mentionables/:mentionable_type/:id', to: 'likes#mentionables', via: :get, as: 'mentionables'

  resources :follows, only: [:create, :destroy] do
    member do
      get :followers
      get :followings
    end
  end

  resources :locations, only: [:show] do
    get :autocomplete_location_name, :on => :collection
    member do
      get :people
    end
  end

  resources :markets, only: [:show]  do
    get :autocomplete_market_name, :on => :collection
    member do
      get :people
    end
  end

  resources :skills, only: [:show]  do
    get :autocomplete_skill_name, :on => :collection
  end

  resources :services, only: [:show]  do
    get :autocomplete_service_name, :on => :collection
  end

  resources :subjects, only: [:show]  do
    get :autocomplete_subject_name, :on => :collection
  end

  resources :technologies , only: [:show] do
    get :autocomplete_technology_name, :on => :collection
  end

  resources :schools do
    get :autocomplete_school_name, :on => :collection
    member do
      get :students
      get :ideas
      get :activities
      get :followers
      get :trending
    end
  end

  get 'check_username', to: 'users#check_username', as: 'check_username'
  get 'check_email', to: 'users#check_email', as: 'check_email'

  resources :conversations, only: [:index, :show, :destroy] do
    member do
      post :reply
      post :restore
      post :mark_as_read
    end
    collection do
      delete :empty_trash
      get :recent
    end
  end

  resources :messages, only: [:new, :create, :destroy]
  resources :notifications, only: [:index] do
    collection do
      post :mark_as_read
    end
  end

  resources :users, path: 'people' do
    get :autocomplete_user_name, :on => :collection
    member do
      get :activities
      put :publish
      put :unpublish
      get :investments
      get :feedbacks
      get :followers
      post :user_invite
      get :followings
      delete :delete_cover
      get :badges
      put :about_me
    end
  end

  resources :comments, only: [:create, :update, :index, :destroy]

  resources :shares, only: [:create, :destroy]

  resources :ideas do
    resources :idea_messages, except: [:show, :new, :edit]
    member do
      put :publish
      put :unpublish
      get :likers
      get :card
      get :join_team
      get :feedbackers
      get :investors
      get :team
      get :comments
      get :updates
      post :invite_team
      get :followers
    end
    resources :investments, only: [:create, :index, :show]
    resources :notes
    resources :feedbacks do
      member do
        put :rate
      end
    end
  end

  get '/:slug', to: SlugRouter.to(:show), as: :profile
  put '/:slug', to: SlugRouter.to(:update), as: :profile_update
  delete '/:slug', to: SlugRouter.to(:destroy), as: :profile_destroy
  get '/:slug/card', to: SlugRouter.to(:card), as: :profile_card
  get '/:slug/people', to: SlugRouter.to(:people), as: :profile_people
  get '/:slug/activities', to: SlugRouter.to(:activities), as: :profile_activities
  get '/:slug/followers', to: SlugRouter.to(:followers), as: :profile_followers
  get '/:slug/feedbacks', to: SlugRouter.to(:feedbacks), as: :profile_feedbacks
  get '/:slug/investments', to: SlugRouter.to(:investments), as: :profile_investments
  get '/:slug/badges', to: SlugRouter.to(:badges), as: :profile_badges
  put '/:slug/publish', to: SlugRouter.to(:publish), as: :profile_publish
  put '/:slug/unpublish', to: SlugRouter.to(:publish), as: :profile_unpublish
  post '/:slug/user_invite', to: SlugRouter.to(:user_invite), as: :profile_user_invite
  get '/:slug/followings', to: SlugRouter.to(:followings), as: :profile_followings
  get '/:slug/comments', to: SlugRouter.to(:comments), as: :profile_comments
  delete '/:slug/delete_cover', to: SlugRouter.to(:delete_cover), as: :profile_delete_cover

end
