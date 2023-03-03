Rails.application.routes.draw do
  root "items#index"

  resources :items, only: %i[index]
  resources :purchases, only: %i[show new create]
  resources :settlement_accounts, only: %i[show update]
end
