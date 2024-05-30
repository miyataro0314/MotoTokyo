Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  root 'static_pages#top'
  get 'home', to: 'homes#home'
  get 'my_page', to: 'homes#my_page'
  get 'my_spots', to: 'homes#my_spots'
  get 'account', to: 'homes#account'

  resources :spots, only: %i[new create edit update show index destroy] do
    resources :bookmarks, only: %i[create destroy]
  end
  resources :parkings, only: %i[show index]
  resources :profiles, only: %i[new create edit update]


  resources :spot_registrations, only: [] do
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

  namespace :api do
    namespace :v1 do
      post 'spots/check', to: 'spots#check'
    end
  end

  namespace :admin do
    devise_scope :user do
      get "/", to: "dashboards#new", as: "root"
      get 'sign_in', to: 'sessions#new'
      post 'sign_in', to: 'sessions#create'
      delete 'sign_out', to: 'sessions#destroy'
    end

    resources :parkings, only: %i[new create show index edit destroy] do
      collection do
        get 'fee_field', to: 'parking_registrations#add_fee_field'
        delete 'fee_field', to: 'parking_registrations#delete_fee_field'
        get 'capacity_field', to: 'parking_registrations#add_capacity_field'
        delete 'capacity_field', to: 'parking_registrations#delete_capacity_field'
      end
    end
  end

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
