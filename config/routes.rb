Rails.application.routes.draw do
  resources :netball_educators
  resources :sponsors
  resources :educators
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "pages#home"
  
  get "pages/educator_sign_up"
  match '/users',   to: 'users#index',   via: 'get'
 

end
