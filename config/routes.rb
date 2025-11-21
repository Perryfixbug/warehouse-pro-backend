Rails.application.routes.draw do
  resources :ordered_products
  resources :orders
  resources :import_orders, controller: "import_orders"
  resources :export_orders, controller: "export_orders"
  resources :agencies
  resources :products
  resources :users
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
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
  root "static_pages#home"
end
