class UserMailer < ApplicationMailer
    def account_created(user, reset_password_token)
      @user = user
      @reset_password_token = reset_password_token
      @reset_password_within = user.class.reset_password_within

      mail(
        to: user.email,
        subject: "Your Netball America account is ready"
      )
    end

    def admin_new_user_alert(user)
      @user = user
      mail(
        to:    "pethicklisa@gmail.com",
        subject: "IMPORTANT: New user: #{user.full_name} (#{user.role.humanize})"
      )
    end
    
    def new_team_sign_up(user)
      @user = user
      mail(
        to: "info@netballamerica.com",
        subject: "New Netball America user registration"
      )
    end
        
  end
