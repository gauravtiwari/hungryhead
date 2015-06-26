Rails.application.routes.draw do

  authenticated do
    root :to => 'activities#index', as: :authenticated
  end

  root 'pages#index'

  #Pages routes
  get '/learn', to: 'pages#learn', as: :learn
  get '/hello', to: 'pages#hello', as: :hello
  get '/rules', to: 'pages#rules', as: :rules

  get '/privacy', to: 'pages#privacy', as: :privacy
  get '/get-started', to: 'pages#get_started', as: :get_started
  get '/product', to: 'pages#product', as: :product
  get '/terms-of-use', to: 'pages#terms', as: :terms
  get '/request-invite', to: 'pages#request_invite', as: :request_invite
  get '/our-story', to: 'pages#story', as: :story
  get '/how-it-works', to: 'pages#how_it_works', as: :how_it_works

  #Soulmate search engine
  mount Soulmate::Server, :at => "/search"

  #Sidekiq
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  #Pusher authentication route
  post "pusher/auth"

  mount Help::Engine => "/help"

  # Upgrade path for old browsers

  get '/browser-upgrade', to: 'pages#upgrade_browser', as: :upgrade

  # Authentication
  devise_for :users, skip: [:sessions, :passwords, :confirmations, :registrations],  controllers: {sessions: 'users/sessions',  invitations: "users/invitations", registrations: 'users/registrations', :confirmations => "users/confirmations"}
  as :user do

    get   '/join' => 'users/registrations#new',    as: 'new_user_registration'
    post  '/join' => 'users/registrations#create', as: 'user_registration'

    # joining
    get   '/invite_friends' => 'users/invitations#new',    as: 'friends_invite'

    # session handling
    get     '/login'  => 'users/sessions#new',     as: 'new_user_session'
    post    '/login'  => 'users/sessions#create',  as: 'user_session'
    get  '/logout' => 'users/sessions#destroy', as: 'destroy_user_session'

    # settings & cancellation
    get '/cancel/:id'   => 'users/registrations#cancel', as: 'cancel_user_registration'
    get '/settings/:id' => 'users/registrations#edit',   as: 'edit_user_registration'
    patch '/settings/:id' => 'users/registrations#update', as: 'update_user_registeration'

    scope '/account' do
      # password reset
      get   '/reset-password'        => 'users/passwords#new',    as: 'new_user_password'
      put   '/reset-password'        => 'users/passwords#update', as: 'user_password'
      post  '/reset-password'        => 'users/passwords#create'
      get   '/reset-password/change' => 'users/passwords#edit',   as: 'edit_user_password'

      # confirmation
      get   '/confirm'        => 'users/confirmations#show',   as: 'user_confirmation'
      post  '/confirm'        => 'users/confirmations#create'
      get   '/confirm/resend' => 'users/confirmations#new',    as: 'new_user_confirmation'

      # account deletion
      delete '' => 'users/registrations#destroy', as: :user_destroy
    end
  end

  #Check if email and username exists
  post 'check_username', to: 'users#check_username', as: 'check_username'
  post 'check_email', to: 'users#check_email', as: 'check_email'

  match '/vote',  to: 'votes#vote', via: :put, as: 'vote'
  get '/:tag/tagged_people',  to: 'tags#people', as: 'tag_people'
  get '/:tag/tagged_ideas',  to: 'tags#show', as: 'tag'
  match '/voters', to: 'votes#voters', via: :get, as: 'voters'
  match '/mentionables/:mentionable_type/:id', to: 'mentions#mentionables', via: :get, as: 'mentionables'

  resources :welcome
  resources :new_idea

  resources :notifications, only: [:index, :update] do
    collection do
      post :mark_as_read
      post :mark_all_as_read
      get :personal
      get :friends
    end
  end

  resources :follows, only: [:create, :destroy] do
    member do
      get :followers
      get :followings
    end
  end

  #Tagging system
  resources :tags, only: [:show]

  #Hobby autocomplete system
  resources :hobbies, only: [:index] do
    get :autocomplete_hobby_name, :on => :collection
  end

  #Skill autocomplete system
  resources :skills, only: [:index] do
    get :autocomplete_skill_name, :on => :collection
  end

  #markets autocomplete system
  resources :markets, only: [:index] do
    get :autocomplete_market_name, :on => :collection
  end

  #subjects autocomplete system
  resources :subjects, only: [:index] do
    get :autocomplete_subject_name, :on => :collection
  end

  #locations autocomplete system
  resources :locations, only: [:index] do
    get :autocomplete_location_name, :on => :collection
  end

  #Schools resources
  resources :schools do
    get :autocomplete_school_name, :on => :collection
    member do
      get :latest_ideas
    end
  end

  #School new and create action
  get 'new_school_registeration', to: 'schools#new', as: :new_school_registeration
  post 'new_school_registeration', to: 'schools#create', as: :school_registeration


  #Messaging system
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

  resources :badges, only: :show

  #Users routes
  resources :users, except: [:show] do
    get :autocomplete_user_name, :on => :collection

    collection do
      get :latest
      get :popular
      get :trending
    end

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

  resources :invite_requests, only: [:create]

  #Comments resources
  resources :comments, only: [:create, :update, :index, :destroy]

  #Ideas routes
  resources :ideas, except: [:new, :edit] do
    #idea messages
    resources :idea_messages, only: [:create, :destroy, :show, :index]
    resources :team_invites, only: [:create, :update, :destroy, :show]

    collection do
      get :latest
      get :popular
      get :trending
    end
    #Member routes
    member do
      put :publish
      put :unpublish
      get :likers
      get :card
      get :join_team
      get :comments
      get :feedbackers
      get :investors
      get :team
      get :comments
      get :updates
      get :followers
    end

    #Investments resource
    resources :investments, only: [:create, :index, :show]

    #Feedback resources
    resources :feedbacks do
      member do
        put :rate
      end
    end

  end

  resources :activities, only: [:index, :show]

  #Vanity urls for users
  get '/:slug', to: SlugRouter.to(:show), as: :profile
  put '/:slug', to: SlugRouter.to(:update), as: :profile_update
  delete '/:slug', to: SlugRouter.to(:destroy), as: :profile_destroy
  get '/:slug/card', to: SlugRouter.to(:card), as: :profile_card
  get '/:slug/events', to: SlugRouter.to(:events), as: :profile_events
  get '/:slug/supports', to: SlugRouter.to(:supports), as: :profile_supports
  get '/:slug/activities', to: SlugRouter.to(:activities), as: :profile_activities
  get '/:slug/activities/:id', to: SlugRouter.to(:activity), as: :profile_activities_activity
  get '/:slug/trending', to: SlugRouter.to(:trending), as: :profile_trending
  get '/:slug/people', to: SlugRouter.to(:people), as: :profile_people
  get '/:slug/ideas', to: SlugRouter.to(:ideas), as: :profile_ideas
  get '/:slug/latest_ideas', to: SlugRouter.to(:latest_ideas), as: :profile_latest_ideas
  get '/:slug/dashboard', to: SlugRouter.to(:dashboard), as: :profile_dashboard
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
