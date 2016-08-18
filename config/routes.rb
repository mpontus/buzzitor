Rails.application.routes.draw do
  root 'core#homepage'
  get '/serviceworker', to: 'core#serviceworker'
  get '/manifest',      to: 'core#manifest'
  namespace :monitoring do
    resources :contexts do
      member do
        resources :subscribers
      end
    end
    resources :results
  end
end
