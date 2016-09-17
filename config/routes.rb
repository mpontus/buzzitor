Rails.application.routes.draw do
  root 'monitoring/contexts#new'
  get '/serviceworker', to: 'core#serviceworker'
  get '/manifest',      to: 'core#manifest'
  namespace :monitoring, path: nil, shallow: true do
    resources :contexts, path: '/'  do
      resources :subscribers, only: [:create]
      # member do
      # end
    end
    resources :results
  end
end
