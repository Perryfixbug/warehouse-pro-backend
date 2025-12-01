Rails.application.routes.draw do
  resources :ordered_products
  resources :orders
  resources :agencies
  resources :products
  resources :users
  get "/me", to: "users#me"
  devise_for :users, 
    controllers: {sessions: 'users/sessions'}, 
    defaults: {format: :json}
  get "dashboard/stats", to: "dashboard#stats"
  get "dashboard/alerts", to: "dashboard#alerts"
  get "dashboard/chart", to: "dashboard#chart"
  post "/csv/create", to: "csv#create"
  get "search/universalSearch", to: "searchs#universalSearch"
  get "search/products", to: "searchs#productSearch"
  get "search/agencies", to: "searchs#agencySearch"
  get "test_notify/:id", to: "tests#ping"

  require "sidekiq/web"
  mount Sidekiq::Web => "/sidekiq"  # http://localhost:3000/sidekiq
  root "users#index"
end
