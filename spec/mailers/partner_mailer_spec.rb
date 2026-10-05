require "rails_helper"

RSpec.describe PartnerMailer, type: :mailer do
  describe "record_allocation_notification" do
    let(:assigner) { create(:user, first_name: "Lisa") }
    let(:assignee) do
      create(
        :user,
        first_name: "Alex",
        last_name: "Morgan",
        email: "alex@example.com"
      )
    end
    let(:partner) do
      build_stubbed(
        :partner,
        user: assignee,
        old_user_id: assigner.id,
        company: "Community Connect Co.",
        description: "Youth engagement partner",
        first_name_primary: "Jane",
        last_name_primary: "Smith",
        email_primary: "jane@partner.org",
        location: "123 Collaboration Blvd",
        city: "San Diego",
        us_state: "CA",
        country: "USA",
        accept_partnership: "Accept"
      )
    end
    let(:mail) do
      described_class.with(partner: partner).record_allocation_notification
    end

    before do
      allow_any_instance_of(User).to receive(:send_admin_alert)
      allow_any_instance_of(User).to receive(:send_sonya_mail)
    end

    it "sends a branded partner summary and action link to the assignee" do
      expect(mail.to).to eq(["alex@example.com"])
      expect(mail.subject).to eq("Partner record assigned to you: Community Connect Co.")
      expect(mail.html_part.body.encoded).to include("A partner record has been assigned to you")
      expect(mail.html_part.body.encoded).to include("Lisa has assigned")
      expect(mail.html_part.body.encoded).to include("Jane Smith")
      expect(mail.html_part.body.encoded).to include("San Diego CA")
      expect(mail.html_part.body.encoded).to include("View partner record")
      expect(mail.html_part.body.encoded).to include("Netball_America_Logo")
      expect(mail.text_part.body.encoded).to include("Hi Alex")
      expect(mail.text_part.body.encoded).to include("/partners/#{partner.id}/edit")
    end

    it "uses a safe fallback when the previous user no longer exists" do
      partner.old_user_id = -1

      expect(mail.html_part.body.encoded).to include("A Netball America administrator has assigned")
    end
  end
end
