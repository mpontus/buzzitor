Rails.application.routes.draw do
  root 'monitoring/contexts#new'
  get '/serviceworker', to: 'core#serviceworker'
  get '/manifest',      to: 'core#manifest'
  namespace :monitoring do
    resources :contexts  do
      resources :subscribers, only: [:create]
      # member do
      # end
    end
    resources :results
  end
  get '/.well-known/acme-challenge/tV5QuMB7r3YItpkHDs882uwGd_Wf-W3bhy4DobY_5Ww', to: 'core#letsencrypt'
end
