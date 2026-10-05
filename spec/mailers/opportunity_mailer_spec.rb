require "rails_helper"

RSpec.describe OpportunityMailer, type: :mailer do
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
    let(:sponsor) { build_stubbed(:sponsor, company_name: "Community Sports Inc") }
    let(:opportunity) do
      build_stubbed(
        :opportunity,
        sponsor: sponsor,
        user: assignee,
        old_user_id: assigner.id,
        opportunity_type: "Cash sponsorship",
        status: "In progress",
        area: "U.S. Open",
        date_submitted: Date.new(2026, 10, 3),
        amount: 5_000
      )
    end
    let(:mail) do
      described_class.with(opportunity: opportunity).record_allocation_notification
    end

    before do
      allow_any_instance_of(User).to receive(:send_admin_alert)
      allow_any_instance_of(User).to receive(:send_sonya_mail)
    end

    it "sends a branded opportunity summary and action link to the assignee" do
      expect(mail.to).to eq(["alex@example.com"])
      expect(mail.subject).to eq("Opportunity assigned to you: Community Sports Inc")
      expect(mail.html_part.body.encoded).to include("An opportunity has been assigned to you")
      expect(mail.html_part.body.encoded).to include("Lisa has assigned")
      expect(mail.html_part.body.encoded).to include("Cash sponsorship")
      expect(mail.html_part.body.encoded).to include("$5,000.00")
      expect(mail.html_part.body.encoded).to include("View opportunity")
      expect(mail.html_part.body.encoded).to include("Netball_America_Logo")
      expect(mail.text_part.body.encoded).to include("Hi Alex")
      expect(mail.text_part.body.encoded).to include("/sponsors/#{sponsor.id}/opportunities/#{opportunity.id}/edit")
    end

    it "uses a safe fallback when the previous user no longer exists" do
      opportunity.old_user_id = -1

      expect(mail.html_part.body.encoded).to include("A Netball America administrator has assigned")
    end
  end
end
