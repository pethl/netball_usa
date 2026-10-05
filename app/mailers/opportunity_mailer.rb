class OpportunityMailer < ApplicationMailer
  default template_path: "opportunity_mailer"

  def record_allocation_notification
    @opportunity = params[:opportunity]
    @assignee = @opportunity.user
    @assigner = User.find_by(id: @opportunity.old_user_id)

    mail(
      to: @assignee.email,
      subject: "Opportunity assigned to you: #{@opportunity.sponsor.company_name}"
    )
  end
end
