Rails.application.routes.draw do
  resources :individual_members
  resources :contacts
  get 'na_teams/index_admin' => 'na_teams#index_admin', :as => :index_admin
  get 'regions/team_list_index' => 'regions#team_list_index', :as => :team_list_index
  get 'na_teams/teams_list_index' => 'na_teams#teams_list_index', :as => :teams_list_index

  resources :regions
  resources :na_teams do
    resources :members, except: [:index, :show]
  end
  resources :na_teams do
    resources :member_key_roles, except: [:index, :show]
  end
  
  resources :follow_ups
  resources :equipment
  resources :sample_words
  resources :budgets
  resources :taems
 
  get '/download_transfers_in_sheet_pdf' => "transfers#download_transfers_in_sheet_pdf" 
  get '/download_transfers_out_sheet_pdf' => "transfers#download_transfers_out_sheet_pdf" 
 
  get 'transfers/index_inbound_pickup' => 'transfers#index_inbound_pickup', :as => :index_inbound_pickup
  get 'transfers/index_outbound_pickup' => 'transfers#index_outbound_pickup', :as => :index_outbound_pickup
 
  get 'events/calendar' => 'events#calendar', :as => :calendar

  get 'people/index_trainers_and_ambassadors' => 'people#index_trainers_and_ambassadors', :as => :index_trainers_and_ambassadors
  get 'people/index_int' => 'people#index_int', :as => :index_int
  get 'people/index_scorers' => 'people#index_scorers', :as => :index_scorers
  get 'people/index_coaches' => 'people#index_coaches', :as => :index_coaches
  get 'people/index_operations' => 'people#index_operations', :as => :index_operations
  get 'people/people_search' => 'people#people_search', :as => :people_search
  
  resources :people
  resources :events
  resources :transfers
  resources :references
  resources :grants
 
  get 'netball_educators/pe_directors' => 'netball_educators#pe_directors', :as => :pe_directors
  get 'netball_educators/search' => 'netball_educators#search', :as => :search
  get 'netball_educators/index_level' => 'netball_educators#index_level', :as => :index_level
  get 'netball_educators/index_state' => 'netball_educators#index_state', :as => :index_state
  get 'netball_educators/index_user' => 'netball_educators#index_user', :as => :index_user
 
  resources :netball_educators
  resources :sponsors do
    resources :opportunities, except: [:index, :show]
  end

  resources :sponsors  do
    resources :contacts, except: [:index, :show]
  end
  resources :educators
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "pages#home"
  
  get "pages/educator_sign_up"
  get "pages/teams_membership_fees"
  get "pages/membership_landing"
  match '/users',   to: 'users#index',   via: 'get'
 
  
  
end
