Rails.application.routes.draw do
  root 'top#index'
  get '/top', to: 'top#index'
end
