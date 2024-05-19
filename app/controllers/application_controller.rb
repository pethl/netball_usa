class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  
  helper_method :is_admin?
 
  def after_sign_in_path_for(resource)
    if current_user.teamlead?
        teams_path
      else
        '/'
      end
  end
  
  def default_url_options
     {:locale => I18n.locale}
   end


    def is_admin?
      user_signed_in? ? current_user.admin : false
    end
    
  protected

   def configure_permitted_parameters
     devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name terms_and_conditions])
     devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name])
   end
   
end
