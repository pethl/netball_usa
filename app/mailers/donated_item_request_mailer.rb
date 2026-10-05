class DonatedItemRequestMailer < ApplicationMailer
  def request_submitted
    @request = params[:request]
    @item = @request.donated_item
    @requestor = @request.requested_by

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

    mail(
      to: @requestor.email,
      subject: "Your Donated Item Request Has Been Approved"
    )
  end
end
