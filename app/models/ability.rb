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

    if user.teamlead?
      can :manage, Club, user_id: user.id # if the user is logged in can manage it's own teams
      can :manage, Member 
      can :manage, IndividualMember
      
    end 

    if user.educators?
      can :manage, NetballEducator
      can :manage, FollowUp
    end

    if user.grants?
      can :manage, Grant
    end

    if  user.teams_grants?
      can :manage, Grant 
      can :manage, Club 
      can :manage, Payment
      can :manage, IndividualMember 
    end

    if  user.teams_admin?
      can :manage, Club # all teams inc proper index and regions list
      can :manage, IndividualMember 
    end

    if user.sponsors?
      can :manage, Sponsor
      can :manage, Contact
      can :manage, Opportunities, user_id: user.id # if the user is assigned in can manage 
    end
  
    if user.admin?
    can :manage, :all # finally we give all remaining permissions only to the admins
    end
  end
    
end
