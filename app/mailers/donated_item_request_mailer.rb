class DonatedItemRequestMailer < Devise::Mailer
  default from: "no-reply@netballamerica.com"

  def request_submitted
    @request = params[:request]
    @item = @request.donated_item
    @requestor = @request.requested_by

    @link = "https://netball-america-923def44b63e.herokuapp.com/donated_item_requests/#{@request.id}"

    mail(
      to: "president@netballamerica.com",
      subject: "Donated Item Request Awaiting Approval"
    )
  end

  def request_approved
    @request = params[:request]
    @item = @request.donated_item
    @requestor = @request.requested_by
    @approver = @request.approved_by

    @link = "https://netball-america-923def44b63e.herokuapp.com/donated_item_requests/#{@request.id}?locale=en"

    mail(
      to: @requestor.email,
      subject: "Your Donated Item Request Has Been Approved"
    )
  end
end
