class Users::RegistrationsController < Devise::RegistrationsController
  ALLOWED_SIGNUP_ROLES = [12].freeze
  PASSWORD_RESET_EMAIL_THROTTLE = 10.minutes
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
      if duplicate_email?
        send_duplicate_account_reset_instructions
        redirect_to new_user_session_path,
                    notice: duplicate_account_notice
        return
      end

      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  protected

  def duplicate_email?
    resource.errors.of_kind?(:email, :taken)
  end

  def send_duplicate_account_reset_instructions
    existing_user = User.find_by(email: resource.email.to_s.strip.downcase)
    return unless existing_user&.account_active?
    return if existing_user.reset_password_sent_at.present? &&
              existing_user.reset_password_sent_at > PASSWORD_RESET_EMAIL_THROTTLE.ago

    existing_user.send_reset_password_instructions
  end

  def duplicate_account_notice
    "If an active account already exists for that email, password reset instructions have been sent. Please check your inbox and spam folder."
  end

  def after_inactive_sign_up_path_for(resource)
    new_user_session_path
  end
end
