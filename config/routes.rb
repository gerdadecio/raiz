Rails.application.routes.draw do
  root to: 'dashboard#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :wallets, only: [:show] do
    member do
      get 'new_fund'
      get 'new_transfer'
      post 'add_fund'
      post 'transfer_fund'
    end
  end
  resources :users
end
