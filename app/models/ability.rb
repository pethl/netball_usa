# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    # start by defining rules for all users, also not logged ones
    can :read, Transfer, public: true  # everyone can see transfer records tselect their name
    can :update, Transfer, public: true  # everyone can update their record NEEDS WORK
    can :create, NetballEducator, public: true # public can create a educator record
    can :show, NetballEducator, public: true
    #return unless user.present?

    unless  user.role.to_s.empty?
    can :manage, User, user_id: user.id
    end

    #role 1 teams_grants
    if  user.teams_grants?
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

    #role 2 Club Managers/was team leads
    if user.teamlead?
      can :manage, Club, user_id: user.id # if the user is logged in can manage it's own teams
      can :manage, Member 
      can :manage, IndividualMember
      
    end 
 
    #role 3 grants
    if user.grants?
      can :manage, Grant
    end

   #role 4 educators
   if user.educators?
    can :manage, NetballEducator
    can :manage, FollowUp
    end

    
    #role 5 all clubs admin - membership
    if  user.teams_admin?
      can :manage, Club # all teams inc proper index and regions list
      can :manage, IndividualMember 
    end

    #role 6 sponsors_events
    if user.sponsors_events?
      can :manage, Sponsor
      can :manage, Contact
      can :manage, Opportunity, user_id: user.id # if the user is assigned in can manage 
      can :manage, Event
    end

    #role 7 us_open
    if user.us_open?
      can :manage, Transfer
      can :manage, Person
    end

    #role 8 educators_events - Dr Marlene given view rights on all teachers - other person in role doesnt have yet
    if user.educators_events?
      can :manage, NetballEducator
      can :manage, FollowUp
      can :manage, Event
    end

     #role 9 sponsors_media
     if user.sponsors_media?
      can :manage, Sponsor
      can :manage, Contact
      can :manage, Opportunity, user_id: user.id # if the user is assigned in can manage 
      can :manage, Medium
    end
   
    if user.admin?
    can :manage, :all # finally we give all remaining permissions only to the admins
    end
  end
    
end
