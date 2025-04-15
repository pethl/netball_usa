# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
   

    if user.nil?
     #  puts "🔥 PUBLIC USER DETECTED – adding public NetballEducator rules"
      can :create, NetballEducator  # let public users create
      can :show, NetballEducator    # optionally allow them to view any educator
    end

    # Allow users to manage their own profile
    if user.present?
      if user.role.present?
        can :manage, User, id: user.id
      else
        can [:read, :update], User, id: user.id
      end
    end

    # role 1 teams_grants
    if user.teams_grants?
      can :manage, Grant 
      can :manage, Person
      can :manage, Member
      can :manage, Program
      can :manage, Event
      can :manage, Venue
      can :manage, Tour
      can :manage, Partner
      can :manage, Club 
      can :manage, Payment
      can :manage, IndividualMember 
    end

    # role 2 Club Managers / was team leads
    if user.teamlead?
      can :manage, Club, user_id: user.id
      can :manage, Member 
      can :manage, IndividualMember
    end 

    # role 3 grants
    if user.grants?
      can :manage, Grant
    end

    # role 4 educators
    if user.educators?
      can :manage, NetballEducator
      can :manage, FollowUp
      can :manage, Equipment
      can :manage, Event
      can :heat_map, NetballEducator
    end

    # role 5 all clubs admin - membership
    if user.teams_admin?
      can :manage, Club
      can :manage, IndividualMember 
    end

    # role 6 sponsors_events
    if user.sponsors_events?
      can :manage, Sponsor
      can :manage, Contact
      can :manage, Opportunity, user_id: user.id
      can :manage, Event
    end

    # role 7 us_open
    if user.us_open?
      can :manage, Transfer
      can :manage, Person
    end

    # role 8 educators_events
    if user.educators_events?
      can :manage, NetballEducator
      can :manage, FollowUp
      can :manage, Event
      can :heat_map, NetballEducator
    end

    # role 9 sponsors_media_events
    if user.sponsors_media_events?
      can :manage, Sponsor
      can :manage, Contact
      can :manage, Opportunity, user_id: user.id
      can :manage, Medium
      can :manage, Event
    end

    # role 10 educators_events_medium
    if user.educators_events_medium?
      can :manage, NetballEducator
      can :manage, FollowUp
      can :manage, Event
      can :manage, Medium
    end

    # role 11 spare
    if user.spare?
      # Currently no specific permissions assigned
      # Add permissions as needed
    end

    # role 12 na_people
    if user.na_people?
      # Can only read and update their own person record
      can [:read, :update], Person, email: user.email
      cannot :index, Person

      # Transfer access scoped to their own person_id
      if (person = Person.find_by(email: user.email))
        can [:read, :create, :update], Transfer, person_id: person.id
        cannot :index, Transfer
      end
    end

    # Final fallback: admin
    if user.admin?
      can :manage, :all
    end
  end
end

