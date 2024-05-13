class AdminMailer < ApplicationMailer
  class AdminMailer < Devise::Mailer
    default from: 'no-reply@netballamerica.com'
    layout 'mailer'

    def new_user_waiting_for_approval(email)
      @email = email
      mail(to: 'pethicklisa@gmail.com', subject: 'IMPORTANT: New user awaiting admin approval')
    end
  end
end
