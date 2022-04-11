Rails.application.routes.draw do
  resources :games
  resources :cells

  root to: 'games#index'
end
