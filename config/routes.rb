Rails.application.routes.draw do
  resources :ordered_products
  resources :orders
  resources :agencies
  resources :products
  resources :users
  resources :csv
  resources :notifications
  get "/me", to: "users#me"
  devise_for :users, 
    controllers: {sessions: 'auth/sessions'}, 
    defaults: {format: :json}
  get "dashboard/stats", to: "dashboard#stats"
  get "dashboard/alerts", to: "dashboard#alerts"
  get "dashboard/chart", to: "dashboard#chart"
  get "search/universalSearch", to: "searchs#universalSearch"
  get "search/products", to: "searchs#productSearch"
  get "search/agencies", to: "searchs#agencySearch"
  get "test_notify/:id", to: "tests#ping"
  mount ActionCable.server => '/cable'
  root "users#index"
end
