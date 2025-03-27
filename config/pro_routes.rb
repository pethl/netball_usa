Rails.application.routes.draw do
  # ========== General Resources ==========
  resources :open_invites
  resources :vendors
  resources :programs
  resources :individual_members
  resources :contacts
  resources :regions
  resources :follow_ups
  resources :equipment
  resources :sample_words
  resources :budgets
  resources :taems
  resources :educators
  resources :references
  resources :grants

  # ========== Media ==========
  resources :media do
    collection do
      get :my_media
    end
  end

  # ========== Admin Namespace ==========
  namespace :admin do
    resources :clubs, only: [:index, :show, :new, :create]
  end

  # ========== Custom Club Routes ==========
  get 'clubs/index_admin' => 'clubs#index_admin', as: :index_admin
  get 'regions/team_list_index' => 'regions#team_list_index', as: :team_list_index
  get 'clubs/teams_list_index' => 'clubs#teams_list_index', as: :teams_list_index
  get 'members' => 'members#index', as: :members

  resources :clubs do
    resources :member_key_roles, except: [:index, :show]
    resources :members, except: [:index, :show]
    resources :teams, except: [:index, :show]
    resources :notes, only: [:new, :create, :edit, :update, :destroy]
  end

  # ========== Tours & Venues ==========
  resources :tours
  resources :venues

  # ========== Payments ==========
  get 'payments/index_indiv' => 'payments#index_indiv', as: :payments_index_indiv
  resources :payments do
    collection do
      get 'list'
    end
  end

  # ========== NA Teams ==========
  resources :na_teams do
    resources :members, except: [:index, :show]
    resources :member_key_roles, except: [:index, :show]
  end

  # ========== People ==========
  get 'people/index_trainers_and_ambassadors' => 'people#index_trainers_and_ambassadors', as: :index_trainers_and_ambassadors
  get 'people/index_int' => 'people#index_int', as: :index_int
  get 'people/index_scorers' => 'people#index_scorers', as: :index_scorers
  get 'people/index_coaches' => 'people#index_coaches', as: :index_coaches
  get 'people/index_operations' => 'people#index_operations', as: :index_operations
  get 'people/people_search' => 'people#people_search', as: :people_search
  resources :people

  # ========== Events ==========
  get 'events/calendar' => 'events#calendar', as: :calendar
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

  # ========== Sponsors ==========
  resources :sponsors do
    resources :opportunities, except: [:index, :show]
    resources :contacts, except: [:index, :show]
  end

  # ========== Opportunities ==========
  resources :opportunities, only: [:index] do
    collection do
      get :my_index
    end
  end

  # ========== Partners ==========
  resources :partners do
    resources :contacts, except: [:index, :show]
  end

  # ========== Netball Educators ==========
  get 'netball_educators/pe_directors' => 'netball_educators#pe_directors', as: :pe_directors
  get 'netball_educators/search' => 'netball_educators#search', as: :search
  get 'netball_educators/index_level' => 'netball_educators#index_level', as: :index_level
  get 'netball_educators/index_state' => 'netball_educators#index_state', as: :index_state
  get 'netball_educators/index_user' => 'netball_educators#index_user', as: :index_user
  resources :netball_educators

  # ========== Devise (Authentication) ==========
  devise_for :users

  # ========== Pages ==========
  root "pages#home"
  get "pages/educator_sign_up"
  get "pages/teams_membership_fees"
  get "pages/membership_landing"
  match '/users', to: 'users#index', via: 'get'
end
