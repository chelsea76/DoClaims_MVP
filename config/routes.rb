Rails.application.routes.draw do

  get 'claim_contacts/index'

  root 'pages#home'

  devise_for :users,
             path: '',
             path_names: {sign_in: 'login', sign_out: 'logout', edit: 'profile', sign_up: 'registration'},
             controllers: {omniauth_callbacks: 'omniauth_callbacks', registrations: 'registrations'}

  resources :users, only: [:show] do
    member do
      post '/verify_phone_number' => 'users#verify_phone_number'
      patch '/update_phone_number' => 'users#update_phone_number'
    end
    resources :contacts, except: [:index, :destroy]
  end



  resources :claims, except: [:edit] do
    member do
      get 'listing'
      get 'pricing'
      get 'description'
      get 'photo_upload'
      get 'amenities'
      get 'location'
      get 'preload'
      get 'preview'
      get 'claim_tasks'
      post 'lost_details'
      patch 'lost_details'
    end
    resources :photos, only: [:create, :destroy]
    resources :reservations, only: [:create]
    resources :tasks do
      collection do
        get :users
      end
    end
    resources :calendars
    resources :contacts, controller: 'claim_contacts' do
      collection do
        get :pick_contact
        get :existing_contacts
        post :save_contact
      end
    end
    resources :damages do
      member do
        get :photo
      end
    end
  end

  resources :guest_reviews, only: [:create, :destroy]
  resources :host_reviews, only: [:create, :destroy]



  get '/your_trips' => 'reservations#your_trips'
  get '/your_reservations' => 'reservations#your_reservations'
  get '/my_tasks' => 'tasks#my_tasks'
  get '/claim_tasks' => 'tasks#claim_tasks'
  get 'search' => 'pages#search'


# ---- AirKong ------
  get 'dashboard' => 'dashboards#index'

  resources :reservations, only: [:approve, :decline] do
    member do
      post '/approve' => "reservations#approve"
      post '/decline' => "reservations#decline"
    end
  end

  resources :revenues, only: [:index]

  resources :conversations, only: [:index, :create]  do
    resources :messages, only: [:index, :create]
  end

  get '/host_calendar' => "calendars#host"
  get '/payment_method' => "users#payment"
  get '/payout_method' => "users#payout"
  post '/add_card' => "users#add_card"

  get '/notification_settings' => 'settings#edit'
  post '/notification_settings' => 'settings#update'

  get '/notifications' => 'notifications#index'

  mount ActionCable.server => '/cable'

end
