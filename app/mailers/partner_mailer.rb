class PartnerMailer < ApplicationMailer
  default template_path: "partner_mailer"

  def record_allocation_notification
    @partner = params[:partner]
    @assignee = @partner.user
    @assigner = User.find_by(id: @partner.old_user_id)

    mail(
      to: @assignee.email,
      subject: "Partner record assigned to you: #{@partner.company}"
    )
  end
end
