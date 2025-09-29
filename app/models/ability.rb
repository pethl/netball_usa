# frozen_string_literal: true

class Ability
  include CanCan::Ability

 
 
  def initialize(user)
    # 🔒 Public user (not logged in)
    alias_action :inbound_pickups,
    :outbound_pickups,
    :download_transfers_in_sheet_pdf,
    :download_transfers_out_sheet_pdf,
    :download_uniforms_pdf,
    :download_attendee_list_pdf,
    :download_flights_pdf,
    to: :read
    
    if user.nil?
      can :create, NetballEducator
      can :show, NetballEducator
      return
    end

    # 🧍 Logged-in user: always allow basic profile access
    cannot :index, User
    can [:read, :update], User, id: user.id

    case user.role
    
      # 1 : teams_grants (teams and grants, events, programs, venues, tours)
    when "teams_grants"
      can :manage, Grant
      can :manage, Person
      can :manage, Member
      can :manage, Program
      can :manage, Event
      cannot :destroy, Event
      can :manage, Venue
      can :manage, Tour
      can :manage, Partner
      can :manage, Club
      can :manage, Payment
      can :manage, IndividualMember

    # 2 : teamlead (teams only)
    when "teamlead"
      # Only manage their own club
      can :manage, Club, user_id: user.id
      cannot :index_admin, Club

      # Only manage members in their club
      can :manage, Member, club: { user_id: user.id }

      # Allow creating a new IndividualMember *if the user doesn't already have one*
      can [:new, :create], IndividualMember do
        IndividualMember.find_by(user_id: user.id).nil?
      end

      # FIX: Add this broader condition for individual members
      can :manage, IndividualMember do |member|
        member.user_id == user.id || member.club&.user_id == user.id
      end

      # Only manage payments linked to their club
      can :read, Payment, club: { user_id: user.id }

      # Allow teamlead to view and edit their own NetballAssociation
      can [:read, :update], NetballAssociation, user_id: user.id

      # Explicitly prevent access to index or others
      cannot :index, NetballAssociation

    # 3 : grants only
    when "grants"
      can :manage, Grant

     # 4 : no_access
    when "no_access"
       # No specific permissions assigned yet

    # 5 : teams admin level
    when "teams_admin"
      can :manage, Club
      can :manage, Member
      can :manage, IndividualMember
      can :manage, Payment
      can :teams_list_index, Club
      

    # 6 : sponsors_events
    when "sponsors_events"
      can :manage, Sponsor
      can :manage, Contact
      can :manage, Opportunity, user_id: user.id
      can :manage, Event
      cannot :destroy, Event
      can :calendar, Event

    # 7 : us_open (US Open and people)
    when "us_open"
      can :manage, Transfer
      can :menu_all, Transfer
      can :inbound_pickups,  Transfer
      can :outbound_pickups, Transfer

      can :manage, Person
       # 🔍 Read-only access to Event
      can [:read, :index, :show], Event
      can :calendar, Event

    # 8 : educators_events (educators, followups and events)
    when "educators_events"
      can :manage, NetballEducator
      can :manage, FollowUp
      can :manage, Equipment
      can :manage, Event
      cannot :destroy, Event
      can :heat_map, NetballEducator

    # 9 : sponsors_media_events
    when "sponsors_media_events"
      can :manage, Sponsor
      can :manage, Contact
      can :manage, Opportunity, user_id: user.id
      can :manage, Event
      cannot :destroy, Event
      can :calendar, Event
      can :manage, Medium
      

    # 10 : educators_events_medium
    when "educators_events_medium"
      can :manage, NetballEducator
      can :manage, FollowUp
      can :manage, Equipment
      can :manage, Event
      cannot :destroy, Event
      can :heat_map, NetballEducator
      can :manage, Medium
      can :manage, Program
      can :manage, Venue
      can :manage, Person
      can :manage, Vendor
      can :manage, Partner
      # 🔒 View-only access for Club and Member
      can :read, Club
      can :read, Member
      can :read, IndividualMember

      # ✅ Custom access to special view action
      can :teams_list_index, Club
      can :index_admin, Club

    # 11 : spare (no specific permissions)
    when "spare"
      # No specific permissions assigned yet

    # 12 : na_people (person and US Open access)  
    when "na_people"
      can [:read, :update], Person, email: user.email
      cannot :index, Person

      if (person = Person.find_by(email: user.email))
        can [:read, :create, :update], Transfer, person_id: person.id
        cannot :index, Transfer
      end

    # 13 : special for Nathalie 
    when "educators_events_self_selftransfer"
      can :manage, NetballEducator
      can :manage, FollowUp
      can :manage, Equipment
      can :manage, Event
      cannot :destroy, Event
      can :heat_map, NetballEducator
      # NEW: manage your own Person (profile) by email
      can :manage, Person, email: user.email

      # NEW: manage Transfers tied to that Person (via association)
      # Works as Transfer belongs_to :person
      can :manage, Transfer
      
      # FOR IF PEOPLE NEED ACCESS TO OWN ONLY 
      # can :manage, Transfer, person: { email: user.email }
      # ✋ ensure the full menu never shows
      # cannot :menu_all, Transfer
      # cannot :inbound_pickups,  Transfer
      # cannot :outbound_pickups, Transfer

      # 0 : admin (everything) 
    when "admin"
      can :manage, :all
    else
      # default fallback for unknown/missing role
      cannot :manage, :all
      cannot :index, User
    end
  end
end
