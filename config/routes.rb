Rails.application.routes.draw do
  resources :netball_academies

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  
  get 'goodbye', to: 'pages#goodbye'

  get "netball_associations/index", to: "netball_associations#index"
  resources :netball_associations 
  
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

    # ========== General Resources ==========
  post 'renew_individual_membership', to: 'individual_members#renew_individual_membership'
  resources :individual_members
  
  resources :contacts
  
  resources :regions

  resources :follow_ups
  resources :equipment
  resources :sample_words
  resources :budgets
  
  # ========== People ==========
  resources :people do
    collection do
      get :print_details_pdf
    end
  end
  
  # ========== Events ==========
  resources :events do
    collection do
      get :calendar
      get 'past', to: 'events#index_past', as: 'past'
      get 'educational', to: 'events#educational', as: 'educational'
      get 'educational_past', to: 'events#educational_past', as: 'educational_past'
      get :show_educators
      get 'my', to: 'events#my', as: 'my'
    end
  
    member do
      get :assign_educators
      post :assign_educators
    end
  end

  # ========== Transfers ==========
  get 'transfers/inbound_sheet', to: 'transfers#download_transfers_in_sheet_pdf', as: :download_transfers_in_sheet_pdf
  get 'transfers/outbound_sheet', to: 'transfers#download_transfers_out_sheet_pdf', as: :download_transfers_out_sheet_pdf
  get 'transfers/uniforms_pdf', to: 'transfers#download_uniforms_pdf', as: :download_uniforms_pdf
  get 'transfers/attendee_list_pdf', to: 'transfers#download_attendee_list_pdf', defaults: { format: :pdf }
  get 'transfers/flights_pdf', to: 'transfers#download_flights_pdf', as: :download_flights_pdf

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
  get 'netball_educators/kidos', to: 'netball_educators#kidos', as: :kidos
  get 'netball_educators/search' => 'netball_educators#search', :as => :search
  get 'netball_educators/index_user' => 'netball_educators#index_user', :as => :index_user
  get 'netball_educators/my_educators' => 'netball_educators#my_educators', :as => :my_educators
  get 'netball_educators/trainers_etc' => 'netball_educators#trainers_etc', as: :trainers_etc
  get 'netball_educators/heat_map' => 'netball_educators#heat_map', as: :heat_map

 
  resources :netball_educators do
    collection do
      get 'pe_directors'
      get 'search'
    end
  end
  

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

    # ========== Papertrail ==========
    resources :audits, only: [:index] do
      collection do
        get :raw
        get :grouped
      end
    end
  
  
  # ========== Pages ==========
  # Defines the root path route ("/")
  root "pages#home"
  post "clubs/:id/renew_membership", to: "clubs#renew_membership", as: :renew_club_membership

  get "pages/educator_sign_up"
  get "pages/teams_membership_fees"
  get "pages/membership_landing"
  match '/users',   to: 'users#index',   via: 'get'

  
end
