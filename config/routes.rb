Rails.application.routes.draw do
  resources :ordered_products
  resources :orders
  resources :import_orders, controller: "import_orders"
  resources :export_orders, controller: "export_orders"
  resources :agencies do
    collection { get :search }
  end

  resources :products do
    collection { get :search }
  end
  resources :users
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  get "/stat",  to: "static_pages#stat"
  get "/about", to: "static_pages#about"
  get "/help",  to: "static_pages#help"
  root "static_pages#home"
end
