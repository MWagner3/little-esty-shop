Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'static_pages#home'

  resources :merchants do
    resources :items, controller: 'merchant_items'
    resources :invoices, controller: 'merchant_invoices'
  end

  resources :invoice_items, only: [:update]
  
  get '/merchants/:id/dashboard', to: 'merchants#dashboard'

  namespace :admin do
    resources :merchants, :invoices
  end

  resources :admin, only: [:index]
end
