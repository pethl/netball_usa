class PagesController < ApplicationController

  skip_before_action :authenticate_user!, only:[:educator_sign_up]
  
  def home
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
