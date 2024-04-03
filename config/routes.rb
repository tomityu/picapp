Rails.application.routes.draw do
  devise_for :master_users, controllers: {
    sessions: 'master_users/sessions'
  }
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    omniauth_callbacks: 'omniauth_callbacks'
  }

  root 'pictures#index'
  resources :pictures, only: %i[index show]
  namespace :master do
    root to: 'dashboard#index'
    get 'dashboard', to: 'dashboard#index'
  end
  namespace :api do
    post 'line_messaging', to: 'line_messaging#create'
  end
end
