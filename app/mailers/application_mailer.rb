class ApplicationMailer < Devise::Mailer
  default from: "no-reply@netballamerica.com"
  layout "mailer"
  include Devise::Controllers::UrlHelpers
    default template_path: 'devise/mailer'
    
    def new_user_waiting_for_approval(email)
      @email = email
      mail(to: 'pethicklisa@gmail.com', subject: 'IMPORTANT: New user awaiting admin approval')
    end

   def new_team_sign_up(email)
    @email = email
    mail(to: 'info@netballamerica.com', subject: 'AUTOMATED NOTICE: New user sign up')
  end

end
