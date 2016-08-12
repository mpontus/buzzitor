Rails.application.routes.draw do
  root 'welcome#index'
  get '/serviceworker', to: 'core#serviceworker'
  get '/manifest',      to: 'core#manifest'
  resources :monitorings
end
