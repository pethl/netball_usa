require "rails_helper"

RSpec.describe MediumMailer, type: :mailer do
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
    let(:medium) do
      build_stubbed(
        :medium,
        user: assignee,
        old_user_id: assigner.id,
        company_name: "The Daily Times",
        media_type: "Newspaper",
        contact_name: "Jamie Reporter",
        contact_email: "jamie@example.com",
        city: "Orlando",
        state: "FL",
        country: "USA"
      )
    end
    let(:mail) do
      described_class.with(medium: medium).record_allocation_notification
    end

    before do
      allow_any_instance_of(User).to receive(:send_admin_alert)
      allow_any_instance_of(User).to receive(:send_sonya_mail)
    end

    it "sends a branded media summary and action link to the assignee" do
      expect(mail.to).to eq(["alex@example.com"])
      expect(mail.subject).to eq("Media record assigned to you: The Daily Times")
      expect(mail.html_part.body.encoded).to include("A media record has been assigned to you")
      expect(mail.html_part.body.encoded).to include("Lisa has assigned")
      expect(mail.html_part.body.encoded).to include("Jamie Reporter")
      expect(mail.html_part.body.encoded).to include("Orlando, FL, USA")
      expect(mail.html_part.body.encoded).to include("View media record")
      expect(mail.html_part.body.encoded).to include("Netball_America_Logo")
      expect(mail.text_part.body.encoded).to include("Hi Alex")
      expect(mail.text_part.body.encoded).to include("/media/#{medium.id}/edit")
    end

    it "uses a safe fallback when the previous user no longer exists" do
      medium.old_user_id = -1

      expect(mail.html_part.body.encoded).to include("A Netball America administrator has assigned")
    end
  end
end
