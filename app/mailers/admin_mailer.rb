class AdminMailer < ApplicationMailer
  class AdminMailer < Devise::Mailer
    default from: 'no-reply@netballamerica.com'
    layout 'mailer'

    def admin_new_user_alert(user)
      @user = user
      mail(
        to:    "pethicklisa@gmail.com",
        subject: "IMPORTANT: New user: #{user.full_name} (#{user.role.humanize})"
      )
    end
  end
end
