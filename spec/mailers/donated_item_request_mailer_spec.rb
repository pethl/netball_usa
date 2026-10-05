require "rails_helper"

RSpec.describe DonatedItemRequestMailer, type: :mailer do
  let(:requestor) do
    create(:user, first_name: "Alex", last_name: "Morgan", email: "alex@example.com")
  end
  let(:item) do
    create(:donated_item, description: "Amazon eGift Card", item_type: "eGift card", value: 25)
  end

  before do
    allow_any_instance_of(User).to receive(:send_admin_alert)
    allow_any_instance_of(User).to receive(:send_sonya_mail)
  end

  describe "request_submitted" do
    let(:request) { create(:donated_item_request, donated_item: item, requested_by: requestor) }
    let(:mail) { described_class.with(request: request).request_submitted }

    it "sends the approver a branded request summary and review link" do
      expect(mail.to).to eq(["president@netballamerica.com"])
      expect(mail.subject).to eq("Donated Item Request Awaiting Approval")
      expect(mail.html_part.body.encoded).to include("Donated item request awaiting approval")
      expect(mail.html_part.body.encoded).to include("Alex Morgan")
      expect(mail.html_part.body.encoded).to include("Amazon eGift Card")
      expect(mail.html_part.body.encoded).to include("Review request")
      expect(mail.html_part.body.encoded).to include("Netball_America_Logo")
      expect(mail.text_part.body.encoded).to include("/donated_item_requests/#{request.id}")
    end
  end

  describe "request_approved" do
    let(:approver) { create(:user, first_name: "Lisa", last_name: "Approver") }
    let(:request) do
      create(
        :donated_item_request,
        :approved,
        donated_item: item,
        requested_by: requestor,
        approved_by: approver
      )
    end
    let(:mail) { described_class.with(request: request).request_approved }

    it "sends the requester a branded approval summary and request link" do
      expect(mail.to).to eq(["alex@example.com"])
      expect(mail.subject).to eq("Your Donated Item Request Has Been Approved")
      expect(mail.html_part.body.encoded).to include("Your donated item request has been approved")
      expect(mail.html_part.body.encoded).to include("Lisa Approver")
      expect(mail.html_part.body.encoded).to include("View request")
      expect(mail.html_part.body.encoded).to include("Netball_America_Logo")
      expect(mail.text_part.body.encoded).to include("Amazon eGift Card")
      expect(mail.text_part.body.encoded).to include("/donated_item_requests/#{request.id}")
    end
  end
end
