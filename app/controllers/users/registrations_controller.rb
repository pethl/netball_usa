class Users::RegistrationsController < Devise::RegistrationsController
  ALLOWED_SIGNUP_ROLES = [12].freeze
  skip_before_action :authenticate_user!, only: [:new, :create]

  # POST /resource
  def create
    build_resource(sign_up_params)

    # 👇 Assign custom role based on param, fallback to default
    resource.role = if ALLOWED_SIGNUP_ROLES.include?(params[:role].to_i)
                      params[:role].to_i
                    else
                      2 # fallback default, matching DB default
                    end

    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        # More specific message about email confirmation
        flash[:notice] = "Please check your email for confirmation details."
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  protected

  def after_inactive_sign_up_path_for(resource)
    new_user_session_path
  end
end