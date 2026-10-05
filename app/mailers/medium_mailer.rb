class MediumMailer < ApplicationMailer
  default template_path: "medium_mailer"

  def record_allocation_notification
    @medium = params[:medium]
    @assignee = @medium.user
    @assigner = User.find_by(id: @medium.old_user_id)

    mail(
      to: @assignee.email,
      subject: "Media record assigned to you: #{@medium.company_name}"
    )
  end
end
