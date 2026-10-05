require "rails_helper"

RSpec.describe EventMailer, type: :mailer do
  describe "assignment_email" do
    let(:user) do
      build_stubbed(
        :user,
        first_name: "Alex",
        last_name: "Morgan",
        email: "alex@example.com"
      )
    end
    let(:event) do
      build_stubbed(
        :event,
        name: "Community Netball Festival",
        event_type: "Festival",
        date: Date.new(2026, 11, 14),
        end_date: nil,
        location: "Central Sports Hall",
        city: "Orlando",
        state: "FL"
      )
    end
    let(:mail) { described_class.assignment_email(user, event) }

    it "sends a branded event summary and link to the assignee" do
      expect(mail.to).to eq(["alex@example.com"])
      expect(mail.subject).to eq("Event assigned to you: Community Netball Festival")
      expect(mail.html_part.body.encoded).to include("An event has been assigned to you")
      expect(mail.html_part.body.encoded).to include("Community Netball Festival")
      expect(mail.html_part.body.encoded).to include("Central Sports Hall, Orlando, FL")
      expect(mail.html_part.body.encoded).to include("View event")
      expect(mail.html_part.body.encoded).to include("Netball_America_Logo")
      expect(mail.text_part.body.encoded).to include("Hi Alex")
      expect(mail.text_part.body.encoded).to include(event_url(event))
    end

    it "handles an event whose date has not been set" do
      event.date = nil

      expect(mail.html_part.body.encoded).to include("To be confirmed")
      expect(mail.text_part.body.encoded).to include("To be confirmed")
    end
  end
end
