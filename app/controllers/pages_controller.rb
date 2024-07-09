class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only:[:educator_sign_up]
  
  def home
    @created_last_7_days = NetballEducator.where("created_at > ?", Time.now-7.days).count
    @created_last_30_days = NetballEducator.where("created_at > ?", Time.now-30.days).count
    @created_this_year = NetballEducator.where("created_at > ?", Time.now.beginning_of_year).count

    @us_umpires = Person.where(role: "Umpire", region: "US & Canada").count
    @int_umpires = Person.where(role: "Umpire", region: "International").count
    @scorers = Person.where(role: "Scorer").count
    @trainers = Person.where(role: "Trainer").count
    @coaches = Person.where(role: "Coach").count
    @operations = Person.where(role: "Operations").count
    
    @admins = User.where(role: 0).count
    @teams_grants = User.where(role: 1).count
    @teamleads = User.where(role: 2).count
    @grants = User.where(role: 3).count
    @educators = User.where(role: 4).count
    @teams_admin = User.where(role: 5).count
    @sponsors = User.where(role: 6).count

    @events_this_year = Event.where('date > ?', Time.now.beginning_of_year)
    @events_this_year_by_status = @events_this_year.group_by { |t| t.status }
    @events_next_year = Event.where('date > ?', Time.now.end_of_year)
    @events_next_year_by_status = @events_next_year.group_by { |t| t.status }

    @operations = Transfer.where(role: "Operations").count
    @umpires = Transfer.where(role: "US Umpire").count
    @int_umpires = Transfer.where(role: "Int Umpire").count
    @scorers = Transfer.where(role: "Scorer").count
    @medics = Transfer.where(role: "Medic").count
  
  end
  
  def educator_sign_up
     @educator = NetballEducator.new
  end

  def membership_landing
    @member_type = get_membership_type
    @individual_member =  IndividualMember.where(email: current_user.email)
  end
  
  private

    def get_users
       @users = User.all
    end
    
    # Only allow a list of trusted parameters through.
    def educator_params
      params.require(:educator).permit(:first_name, :last_name, :email, :phone, :school_name, :city, :state, :educator_notes, :mgmt_notes, :user_id)
    end
    
    def get_membership_type
      @individual_membership = IndividualMember.where(email: current_user.email)
      @team_membership = NaTeam.where(user_id: current_user.id)
      
      if @individual_membership.any?
        return "Individual"
      elsif @team_membership.any?
        return "Team"
      else
        return "None"
      end 
  end
    
end
