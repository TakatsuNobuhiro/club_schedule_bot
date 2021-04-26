Rails.application.routes.draw do
  resources :widgets

  root 'calendar#index'
  
  # for LINE webhook
  post '/callback' => 'webhook#callback'
  get "oauth2callback", to:"calendar#callback"
  get 'calendar/index', to:"calendar#index"


end
