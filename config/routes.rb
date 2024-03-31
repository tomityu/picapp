Rails.application.routes.draw do
  root 'top#index'
  get '/top', to: 'top#index'

  namespace :api do
    post 'line_messaging', to: 'line_messaging#create'
  end
end
