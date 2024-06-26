Rails.application.routes.draw do
  root 'pictures#index'
  devise_for :master_users, controllers: {
    sessions: 'master_users/sessions'
  }
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    omniauth_callbacks: 'omniauth_callbacks'
  }

  resources :pictures, only: %i[index update]
  namespace :master do
    root to: 'dashboards#show'
    resource :dashboard, only: %i[show]
    resource :broadcast, only: %i[new create]
    get 'pictures', to: 'pictures#index'
    get 'pictures/download', to: 'pictures#download'
    get 'results', to: 'results#show'
    get 'results/new', to: 'results#new'
    post 'results', to: 'results#create'
    get 'results/presentation', to: 'results#presentation'
  end
  namespace :api do
    post 'line_messaging', to: 'line_messaging#create'
  end
end
