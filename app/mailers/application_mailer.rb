class ApplicationMailer < Devise::Mailer
  default from: "lisa@redrink.co.uk"
  layout "mailer"
  include Devise::Controllers::UrlHelpers
    default template_path: 'devise/mailer'
    
    def new_user_waiting_for_approval(email)
      @email = email
      mail(to: 'pethicklisa@gmail.com', subject: 'IMPORTANT: New user awaiting admin approval')
    end
end
