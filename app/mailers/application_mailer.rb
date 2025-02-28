class ApplicationMailer < Devise::Mailer
  default from: "no-reply@netballamerica.com"
  layout "mailer"
  include Devise::Controllers::UrlHelpers
    default template_paths: 'devise/mailer'
    
   
end
