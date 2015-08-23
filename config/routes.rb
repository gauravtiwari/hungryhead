Rails.application.routes.draw do

  authenticated do
    root :to => 'ideas#index', as: :authenticated
  end

  root 'pages#home'

  #Pages routes
  get '/learn-about-hungryhead', to: 'pages#learn', as: :learn
  get '/why-hungryhead', to: 'pages#why', as: :why
  get '/community-guidelines', to: 'pages#community_guidelines', as: :rules
  get '/product-tour/gamification', to: 'pages#gamification', as: :gamification
  get '/product-tour/collaboration', to: 'pages#collaboration', as: :collaboration
  get '/product-tour/for-academic-institutions', to: 'pages#for_institutions', as: :for_institutions

  #get '/our-pricing', to: 'pages#pricing', as: :pricing

  # Upgrade path for old browsers
  get '/browser-upgrade', to: 'pages#upgrade_browser', as: :upgrade
  get '/privacy-policy', to: 'pages#privacy_policy', as: :privacy
  get '/cookies-policy', to: 'pages#cookies_policy', as: :cookies
  get '/get-started', to: 'pages#get_started', as: :get_started
  get '/product-tour', to: 'pages#product', as: :product
  get '/terms-of-service', to: 'pages#terms', as: :terms
  get '/our-story', to: 'pages#story', as: :story
  get '/how-it-works', to: 'pages#how_it_works', as: :how_it_works

  resources :csp_reports, only: [:create]

  #Soulmate search engine
  authenticated do
    mount Soulmate::Server, :at => "/search"
  end

  #Sidekiq
  authenticate :user, lambda { |u| u.admin? } do
    require 'sidekiq/web'
    mount Sidekiq::Web => '/background_jobs'
  end

  #Pusher authentication route
  post "pusher/auth"

  mount Help::Engine => "/help"
  mount SiteFeedback::Engine => "/collaborate-with-us"

  # Authentication
  devise_for :users, skip: [:sessions, :passwords, :confirmations, :registrations],  controllers: {sessions: 'users/sessions',  invitations: "users/invitations", registrations: 'users/registrations', :confirmations => "users/confirmations"}
  as :user do

    get   '/join' => 'users/registrations#new',    as: 'new_user_registration'
    post  '/join' => 'users/registrations#create', as: 'user_registration'

    # joining
    get   '/invite_friends' => 'users/invitations#new',    as: 'friends_invite'

    # # session handling
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

  get '/people/:tag',  to: 'tags#people', as: 'tag_people'
  get '/ideas/:tag',  to: 'tags#show', as: 'tag'
  match '/mentionables/:mentionable_type/:id', to: 'mentions#mentionables', via: :get, as: 'mentionables'

  resources :welcome
  resources :new_idea

  resources :notifications, only: [:index, :update] do
    member do
      get :ideas
    end
    collection do
      post :mark_as_read
      post :mark_all_as_read
      get :personal
      get :friends
    end
  end

  resources :follows, only: :create do
    collection do
      post :follow
      delete :unfollow
      get :followers
      get :followings
    end
  end

  resources :votes, only: :create do
    collection do
      post :vote
      delete :unvote
      get :voters
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


  resources :badges, only: :show

  #Users routes
  resources :users, path: 'people', except: [:show] do
    get :autocomplete_user_name, :on => :collection
    collection do
      get :latest
      get :people_you_may_know
      get :popular
      get :trending
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
      get :changes
      get :feedbackers
      get :investors
      get :team
      get :comments
      get :voters
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

  #Activities routes
  resources :activities, only: [:index, :show]

  #Events routes
  resources :events do
    #Attending event
    resources :event_attendees, only: :index
    post :join, to: 'event_attendees#join'
    delete :leave, to: 'event_attendees#leave'

    member do
      put :publish
      put :unpublish
      get :attendees
      get :comments
    end
  end

  resources :shares

  #Vanity urls for users
  get '/:slug', to: SlugRouter.to(:show), as: :profile
  put '/:slug', to: SlugRouter.to(:update), as: :profile_update
  delete '/:slug', to: SlugRouter.to(:destroy), as: :profile_destroy
  get '/:slug/card', to: SlugRouter.to(:card), as: :profile_card
  get '/:slug/about-me', to: SlugRouter.to(:about_me), as: :profile_about_me
  get '/:slug/edit', to: SlugRouter.to(:edit), as: :profile_edit
  get '/:slug/supports', to: SlugRouter.to(:supports), as: :profile_supports
  get '/:slug/events', to: SlugRouter.to(:events), as: :profile_events
  get '/:slug/activities', to: SlugRouter.to(:activities), as: :profile_activities
  get '/:slug/activities/:id', to: SlugRouter.to(:activity), as: :profile_activities_activity
  get '/:slug/trending', to: SlugRouter.to(:trending), as: :profile_trending
  get '/:slug/people', to: "schools#people", as: :profile_people
  get '/:slug/students', to: "schools#students", as: :profile_students
  get '/:slug/faculties', to: "schools#faculties", as: :profile_faculties
  get '/:slug/ideas', to: SlugRouter.to(:ideas), as: :profile_ideas
  get '/:slug/latest_ideas', to: SlugRouter.to(:latest_ideas), as: :profile_latest_ideas
  get '/:slug/dashboard', to: SlugRouter.to(:dashboard), as: :profile_dashboard
  get '/:slug/feedbacks', to: SlugRouter.to(:feedbacks), as: :profile_feedbacks
  get '/:slug/investments', to: SlugRouter.to(:investments), as: :profile_investments
  get '/:slug/badges', to: SlugRouter.to(:badges), as: :profile_badges
  post '/:slug/user_invite', to: SlugRouter.to(:user_invite), as: :profile_user_invite
  get '/:slug/comments', to: SlugRouter.to(:comments), as: :profile_comments
  delete '/:slug/delete_cover', to: SlugRouter.to(:delete_cover), as: :profile_delete_cover

end
