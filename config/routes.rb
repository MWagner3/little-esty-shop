Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'static_pages#home'

  resources :merchants do
    resources :items, controller: 'merchant_items'
  end

  get '/merchants/:id/dashboard', to: 'merchants#dashboard'
  get '/merchants/:id/invoices', to: 'merchant_invoices#index'

  namespace :admin do
    resources :merchants, :invoices
  end

  resources :admin, only: [:index]
end
