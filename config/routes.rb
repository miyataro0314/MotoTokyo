Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords'
  }

  root 'static_pages#top'
  get 'about', to: 'static_pages#about'
  get 'guide', to: 'static_pages#guide'
  get 'contact', to: 'static_pages#contact'
  post 'contact', to: 'static_pages#send_contact'
  get 'privacy_policy', to: 'static_pages#privacy_policy'
  get 'terms', to: 'static_pages#terms'
  get 'side_menu', to: 'static_pages#side_menu'
  get 'home', to: 'homes#home'
  get 'weather_detail', to: 'homes#weather_detail'
  get 'my_page', to: 'homes#my_page'
  get 'my_spots', to: 'homes#my_spots'
  get 'account', to: 'homes#account'
  get 'account/cancellation', to: 'homes#cancellation'

  resources :spots, only: %i[new create edit update show index destroy] do
    resources :bookmarks, only: %i[create destroy]
    resources :comments, only: %i[new index create edit update destroy]
    resources :difficulties, only: %i[show create update]
  end
  resources :parkings, only: %i[show index]
  resources :profiles, only: %i[new create edit update]
  resources :users, only: %i[show]

  resources :friendships do
    collection do
      get 'add_friend'
      post 'user_search'
      post 'send_request'
      post 'approve_request'
      delete 'deny_request'
    end
  end

  resources :spot_registrations do
    collection do
      get 'step1'
      get 'step2'
      get 'step3'
      get 'step4'
      get 'confirmation'
      get 'success'
      get 'failure'
    end
  end

  resources :searches, only: %i[new] do
    collection do
      get 'search_spots_modal'
      get 'search_spots'
    end
  end

  resources :map_views, only: %i[new] do
    collection do
      get 'spot_mini_card/:id', to: 'map_views#spot_mini_card'
      get 'parking_mini_card/:id', to: 'map_views#parking_mini_card'
    end
  end

  resources :notifications, only: %i[index show] do
    collection do
      get 'latest_notifications'
    end
  end

  namespace :api do
    namespace :v1 do
      namespace :user_registrations do
        post 'check_id'
        post 'check_email'
      end
      namespace :spots do
        post 'check'
      end
      namespace :searches do
        post 'load_map_data'
      end
    end
  end

  namespace :admin do
    devise_scope :user do
      get "/", to: "dashboards#new", as: "root"
      get 'sign_in', to: 'sessions#new'
      post 'sign_in', to: 'sessions#create'
      delete 'sign_out', to: 'sessions#destroy'
    end

    resources :parkings, only: %i[new create show index edit update destroy] do
    end
  end

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
