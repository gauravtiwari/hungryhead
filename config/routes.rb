Rails.application.routes.draw do

  resources :mentions

  authenticated do
    root :to => 'activities#index', as: :authenticated
  end

  root 'pages#index'

  #Pages routes
  get '/learn', to: 'pages#learn', as: :learn
  get '/hello', to: 'pages#hello', as: :hello
  get '/rules', to: 'pages#rules', as: :rules

  get '/help', to: 'pages#help', as: :help
  get '/privacy', to: 'pages#privacy', as: :privacy
  get '/get-started', to: 'pages#get_started', as: :get_started
  get '/terms-of-use', to: 'pages#terms', as: :terms
  get '/our-story', to: 'pages#story', as: :story

  #Soulmate search engine
  mount Soulmate::Server, :at => "/search"

  #Sidekiq
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  #Pusher authentication route
  post "pusher/auth"


  # Authentication
  devise_for :users, skip: [:sessions, :passwords, :confirmations, :registrations],  controllers: {sessions: 'users/sessions',  invitations: "users/invitations", registrations: 'users/registrations', :confirmations => "users/confirmations"}
  as :user do

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

  devise_for :students, skip: [:sessions, :passwords, :confirmations, :registrations], controllers: {sessions: 'users/sessions',  invitations: "users/invitations", :confirmations => "users/confirmations", registrations: 'students/registrations'}
  as :student do
    # joining
    get   '/students_join' => 'students/registrations#new',    as: 'new_student_registration'
    post  '/students_join' => 'students/registrations#create', as: 'student_registration'
  end

  devise_for :mentors, skip: [:sessions, :passwords, :confirmations, :registrations], controllers: {sessions: 'users/sessions',  invitations: "users/invitations", :confirmations => "users/confirmations", registrations: 'mentors/registrations'}
  as :mentor do
    # mentor joining
    get   '/mentors_join' => 'mentors/registrations#new',    as: 'new_mentor_registration'
    post  '/mentors_join' => 'mentors/registrations#create', as: 'mentor_registration'
  end

  devise_for :teachers, skip: [:sessions, :passwords, :confirmations, :registrations], controllers: {sessions: 'users/sessions',  invitations: "users/invitations", :confirmations => "users/confirmations", registrations: 'teachers/registrations'}
  as :teacher do
    # teacher joining
    get   '/teachers_join' => 'teachers/registrations#new',    as: 'new_teacher_registration'
    post  '/teachers_join' => 'teachers/registrations#create', as: 'teacher_registration'
  end

  match '/vote',  to: 'votes#vote', via: :put, as: 'vote'
  get '/:tag/people',  to: 'tags#people', as: 'tag_people'
  get '/:tag/ideas',  to: 'tags#show', as: 'tag'
  match '/voters', to: 'votes#voters', via: :get, as: 'voters'
  match '/sharers', to: 'shares#sharers', via: :get, as: 'sharers'
  match '/mentionables/:mentionable_type/:id', to: 'mentions#mentionables', via: :get, as: 'mentionables'

  resources :welcome
  resources :new_idea

  resources :notifications, only: [:index, :update] do
    member do
      get :ideas
    end
    collection do
      post :mark_as_read
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
  resources :tags, only: [:show] do
    member do
      get :people
    end
  end

  #Hobby autocomplete system
  resources :hobbies, only: [:index] do
    get :autocomplete_hobby_name, :on => :collection
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
      get :latest_students
      get :latest_faculties
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
  resources :users, path: 'people', except: [:show] do
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

  #Comments resources
  resources :comments, only: [:create, :update, :index, :destroy]

  #Shares resources
  resources :shares, only: [:create, :destroy, :show] do
    member do
      get :sharers
    end
  end

  #Ideas routes
  resources :ideas, path: 'ideas', except: [:new, :edit] do
    #idea messages
    resources :idea_messages, only: [:create, :destroy, :show, :index]
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
      post :invite_team
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

  resources :posts, only: [:create, :destroy, :update]
  resources :activities, only: [:index, :show]

  #Vanity urls for users
  get '/:slug', to: SlugRouter.to(:show), as: :profile
  put '/:slug', to: SlugRouter.to(:update), as: :profile_update
  delete '/:slug', to: SlugRouter.to(:destroy), as: :profile_destroy
  get '/:slug/card', to: SlugRouter.to(:card), as: :profile_card
  get '/:slug/posts', to: SlugRouter.to(:posts), as: :profile_posts
  get '/:slug/posts/:id', to: SlugRouter.to(:post), as: :profile_posts_post
  get '/:slug/activities', to: SlugRouter.to(:activities), as: :profile_activities
  get '/:slug/activities/:id', to: SlugRouter.to(:activity), as: :profile_activities_activity
  get '/:slug/students', to: SlugRouter.to(:students), as: :profile_students
  get '/:slug/trending', to: SlugRouter.to(:trending), as: :profile_trending
  get '/:slug/ideas', to: SlugRouter.to(:ideas), as: :profile_ideas
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
