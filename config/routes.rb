Rails.application.routes.draw do
  root 'core#homepage'
  get '/serviceworker', to: 'core#serviceworker'
  get '/manifest',      to: 'core#manifest'
  namespace :monitoring do
    resources :contexts, only: [:show, :new, :create]  do
      resources :subscribers, only: [:create]
      # member do
      # end
    end
    resources :results
  end
end
