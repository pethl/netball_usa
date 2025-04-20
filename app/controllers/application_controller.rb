class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  before_action :set_paper_trail_whodunnit #For papertrail
  skip_before_action :authenticate_user!, if: :devise_controller?  # Add this line
  #include AbstractController::Rendering
  helper_method :is_admin?


 
  def after_sign_in_path_for(resource)
    if current_user.teamlead?
      pages_membership_landing_path
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

    def after_sign_out_path_for(resource_or_scope)
      goodbye_path # 👈 you control this!
    end

    # rescue_from StandardError,
    # :with => :render_error
    # rescue_from ActionController::RoutingError,
    # :with => :render_not_found
    # rescue_from AbstractController::ActionNotFound,
    # :with => :render_not_found
    rescue_from ActionController::InvalidAuthenticityToken do |exception|
      redirect_to main_app.new_user_session_url, :alert => "Email or Password Incorrect"
    end
    rescue_from CanCan::AccessDenied do |exception|
      redirect_to main_app.root_url, :alert => exception.message
    end
    
  protected

   def configure_permitted_parameters
     devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name terms_and_conditions])
     devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name])
   end
   
end
