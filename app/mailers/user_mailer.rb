class UserMailer < ApplicationMailer
    
    

    def admin_new_user_alert(user)
      @user = user
      mail(
        to:    "pethicklisa@gmail.com",
        subject: "IMPORTANT: New user: #{user.full_name} (#{user.role.humanize})"
      )
    end
    
    def new_team_sign_up(email)
      @email = email
      mail(to: 'info@netballamerica.com', subject: 'AUTOMATED NOTICE: New user sign up')
    end
        
  end