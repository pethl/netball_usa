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
    @grants = User.where(role: 2).count
    @teamleads = User.where(role: 3).count
    @educators = User.where(role: 4).count

  end
  
  def educator_sign_up
     @educator = NetballEducator.new
  end
  
  private

    def get_users
       @users = User.all
    end
    
    # Only allow a list of trusted parameters through.
    def educator_params
      params.require(:educator).permit(:first_name, :last_name, :email, :phone, :school_name, :city, :state, :educator_notes, :mgmt_notes, :user_id)
    end
end
