class GrantMailer < ApplicationMailer
  default template_path: "grant_mailer"

  def record_allocation_notification
    @grant = params[:grant]
    @assignee = @grant.user
    @assigner = User.find_by(id: @grant.old_user_id)

    mail(
      to: @assignee.email,
      subject: "Grant assigned to you: #{@grant.name}"
    )
  end
end
