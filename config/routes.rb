Rails.application.routes.draw do
  get '/games', to: 'games#index'

  get '/cells', to: 'cells#index'
end
