require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "account_created" do
    let(:user) { build_stubbed(:user, first_name: "Alex", email: "alex@example.com") }
    let(:mail) { described_class.account_created(user, "raw-one-time-token") }

    it "includes the username and secure setup link without a plaintext password" do
      expect(mail.to).to eq(["alex@example.com"])
      expect(mail.subject).to eq("Your Netball America account is ready")
      expect(mail.html_part.body.encoded).to include("alex@example.com")
      expect(mail.html_part.body.encoded).to include("reset_password_token=raw-one-time-token")
      expect(mail.html_part.body.encoded).not_to include("password123")
      expect(mail.html_part.body.encoded).to include("expires in 7 days")
      expect(mail.html_part.body.encoded).to include("info@netballamerica.com")
      expect(mail.html_part.body.encoded).to include("pethicklisa@gmail.com")
      expect(mail.text_part.body.encoded).to include("one-time link")
      expect(mail.text_part.body.encoded).to include("expires in 7 days")
      expect(mail.text_part.body.encoded).to include("info@netballamerica.com")
      expect(mail.text_part.body.encoded).to include("pethicklisa@gmail.com")
    end
  end

  describe "new_team_sign_up" do
    let(:user) do
      build_stubbed(
        :user,
        first_name: "Helen",
        last_name: "Example",
        email: "heel@gmail.com"
      )
    end
    let(:mail) { described_class.new_team_sign_up(user) }

    it "sends a simple branded registration notification" do
      expect(mail.to).to eq(["info@netballamerica.com"])
      expect(mail.subject).to eq("New Netball America user registration")
      expect(mail.html_part.body.encoded).to include("New user registration")
      expect(mail.html_part.body.encoded).to include("has been registered")
      expect(mail.html_part.body.encoded).to include("Helen Example")
      expect(mail.html_part.body.encoded).to include("heel@gmail.com")
      expect(mail.html_part.body.encoded).to include("Netball_America_Logo")
      expect(mail.text_part.body.encoded).to include("Helen Example")
      expect(mail.text_part.body.encoded).to include("heel@gmail.com")
    end
  end
end
