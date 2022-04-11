Rails.application.routes.draw do
  resources :games

  get '/cells', to: 'cells#index'
end
