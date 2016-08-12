Rails.application.routes.draw do
  root 'welcome#index'
  get '/serviceworker', to: 'core#serviceworker'
  get '/manifest',      to: 'core#manifest'
  namespace :monitoring do
    resources :contexts
    resources :results
  end
end
