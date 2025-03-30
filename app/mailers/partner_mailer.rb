class PartnerMailer < ApplicationMailer
  default from: 'no-reply@netballamerica.com'
  default template_path: 'partner_mailer'

  def record_allocation_notification
    @partner = params[:partner]

    @new_user = User.find_by(id: @partner.user_id)
    @old_user = User.find_by(id: @partner.old_user_id)

    @partner_record_id = @partner.id
    @object_type = @partner.class.name

    @link = "https://netball-america-923def44b63e.herokuapp.com/partners/#{@partner_record_id}/edit?locale=en"

    mail(
      to: @new_user&.email || "admin@netballamerica.com", # fallback if something is missing
      subject: "IMPORTANT: A Partner record has been allocated to you by #{@old_user&.first_name || 'someone'}."
    )
  end
end
