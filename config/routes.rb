Rails.application.routes.draw do
  resources :sample_words
  resources :budgets
  get 'events/calendar' => 'events#calendar', :as => :calendar
  
  get 'people/index_int' => 'people#index_int', :as => :index_int
  get 'people/index_scorers' => 'people#index_scorers', :as => :index_scorers
 
  resources :people
  resources :events
  resources :transfers
  resources :references
  resources :grants
 
  get 'netball_educators/index_level' => 'netball_educators#index_level', :as => :index_level
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
