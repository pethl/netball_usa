require "rails_helper"

RSpec.describe Devise::Mailer, type: :mailer do
  describe "reset_password_instructions" do
    let(:user) do
      build_stubbed(
        :user,
        first_name: "Alex",
        email: "alex@example.com"
      )
    end
    let(:mail) do
      described_class.reset_password_instructions(user, "raw-reset-token")
    end

    it "sends branded, expiring reset instructions without exposing a password" do
      expect(mail.to).to eq(["alex@example.com"])
      expect(mail.subject).to eq("Reset your Netball America password")
      expect(mail.html_part.body.encoded).to include("Hi Alex")
      expect(mail.html_part.body.encoded).to include("Reset my password")
      expect(mail.html_part.body.encoded).to include("reset_password_token=raw-reset-token")
      expect(mail.html_part.body.encoded).to include("expires in 7 days")
      expect(mail.html_part.body.encoded).to include("Netball_America_Logo")
      expect(mail.html_part.body.encoded).not_to include("password123")
      expect(mail.text_part.body.encoded).to include("info@netballamerica.com")
      expect(mail.text_part.body.encoded).to include("pethicklisa@gmail.com")
    end
  end
end
