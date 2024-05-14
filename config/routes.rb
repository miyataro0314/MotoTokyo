Rails.application.routes.draw do
  devise_for :users
  
  root 'static_pages#top'
  get '/home', to: 'homes#top', as: :home

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
