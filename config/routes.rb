Rails.application.routes.draw do
  resources :sponsors
  resources :educators
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "pages#home"
  
  get "pages/rolodex"
  match '/users',   to: 'users#index',   via: 'get'
 

end
