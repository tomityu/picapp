Rails.application.routes.draw do
  root 'pictures#index'
  devise_for :master_users, controllers: {
    sessions: 'master_users/sessions'
  }
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    omniauth_callbacks: 'omniauth_callbacks'
  }

  resources :pictures, only: %i[index show]
  namespace :master do
    root to: 'dashboard#index'
    get 'dashboard', to: 'dashboard#index'
  end
  namespace :api do
    post 'line_messaging', to: 'line_messaging#create'
  end
end
