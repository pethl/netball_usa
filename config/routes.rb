Rails.application.routes.draw do

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  
  resources :open_invites
  resources :vendors

  # ========== Media ==========
  resources :media do
    collection do
      get :my_media
      get :published
    end
  end


  resources :programs

  namespace :admin do
    resources :clubs, only: [:index, :show, :new, :create]
  end

  get 'clubs/index_admin' => 'clubs#index_admin', :as => :index_admin
  get 'regions/team_list_index' => 'regions#team_list_index', :as => :team_list_index
  get 'clubs/teams_list_index' => 'clubs#teams_list_index', :as => :teams_list_index
  get 'members' => 'members#index', :as => :members

  resources :clubs do
    resources :member_key_roles, except: [:index, :show]
    resources :members, except: [:index, :show]
    resources :teams, except: [:index, :show]
    resources :notes, only: [:new, :create, :edit, :update, :destroy]
  end
 
  resources :tours
  resources :venues

  get 'payments/index_indiv' => 'payments#index_indiv', :as => :payments_index_indiv
  resources :payments do
  collection do
    get 'list'
  end 
  end
  
  resources :individual_members
  resources :contacts
  
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

  
  # ========== People ==========
  resources :people do
    collection do
      get :print_details_pdf
    end
  end
  
  
    # ========== Events ==========
  get 'events/calendar' => 'events#calendar', :as => :calendar
  resources :events do
    collection do
      get 'past', to: 'events#index_past', as: 'past'
    end
  end

  # ========== Transfers ==========
  get 'transfers/inbound_sheet', to: 'transfers#download_transfers_in_sheet_pdf', as: :download_transfers_in_sheet_pdf
  get 'transfers/outbound_sheet', to: 'transfers#download_transfers_out_sheet_pdf', as: :download_transfers_out_sheet_pdf

  resources :transfers do
    collection do
      get :inbound_pickups
      get :outbound_pickups
    end
  
    member do
      get :external_edit
    end
  end
  
  
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

  # ========== Opportunities ==========
  resources :opportunities, only: [:index] do
    collection do
      get :my_index       # /opportunities/my_index
      get :closed         # /opportunities/closed
    end
  end
  
  # ========== Partners ==========
  resources :partners do
    collection do
      get :my_partners
    end
  
    resources :contacts, except: [:index, :show]
  end

  resources :sponsors  do
    resources :contacts, except: [:index, :show]
  end

  resources :educators
  
  # ========== Pages ==========
  # Defines the root path route ("/")
  root "pages#home"
  get "pages/educator_sign_up"
  get "pages/teams_membership_fees"
  get "pages/membership_landing"
  match '/users',   to: 'users#index',   via: 'get'

  
end
