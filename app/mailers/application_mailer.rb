class ApplicationMailer < Devise::Mailer
  default from: "lisa@redrink.co.uk"
  layout "mailer"
  include Devise::Controllers::UrlHelpers
    default template_path: 'devise/mailer'
end
