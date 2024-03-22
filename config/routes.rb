Rails.application.routes.draw do
 
  get 'umpires/index_int' => 'umpires#index_int', :as => :index_int
  get 'umpires/index_scorers' => 'umpires#index_scorers', :as => :index_scorers
 
  resources :umpires
  resources :references
  resources :grants
 
  get 'netball_educators/index_state' => 'netball_educators#index_state', :as => :index_state
  get 'netball_educators/index_user' => 'netball_educators#index_user', :as => :index_user
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
