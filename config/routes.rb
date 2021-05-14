Rails.application.routes.draw do
  resources :categories
  get '/orders/new_order', to: 'orders#new', as: 'orders_new'
  resources :orders
  devise_for :admins
  root 'home#index'
  namespace :admins do
    resources :products
    namespace :products do
      post 'csv_upload'
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end