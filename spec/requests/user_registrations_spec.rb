require "rails_helper"

RSpec.describe "User registration recovery", type: :request do
  before do
    allow_any_instance_of(User).to receive(:send_admin_alert)
    allow_any_instance_of(User).to receive(:send_sonya_mail)
  end

  it "emails reset instructions when someone signs up with an active account's email" do
    existing_user = create(:user, email: "returning.user@example.com")
    ActionMailer::Base.deliveries.clear

    expect do
      post user_registration_path, params: {
        user: signup_attributes(email: " RETURNING.USER@example.com ")
      }
    end.not_to change(User, :count)

    expect(ActionMailer::Base.deliveries.size).to eq(1)
    expect(ActionMailer::Base.deliveries.last.to).to eq(["returning.user@example.com"])
    expect(ActionMailer::Base.deliveries.last.subject).to eq("Reset your Netball America password")
    expect(existing_user.reload.reset_password_token).to be_present
    expect(response).to redirect_to(new_user_session_path(locale: :en))
    expect(flash[:notice]).to include("password reset instructions")
  end

  it "does not send another email within the ten-minute throttle window" do
    existing_user = create(
      :user,
      email: "recent-reset@example.com",
      reset_password_sent_at: 5.minutes.ago,
      reset_password_token: "existing-encrypted-token"
    )
    ActionMailer::Base.deliveries.clear

    expect do
      post user_registration_path, params: {
        user: signup_attributes(email: existing_user.email)
      }
    end.not_to change { ActionMailer::Base.deliveries.count }

    expect(existing_user.reload.reset_password_token).to eq("existing-encrypted-token")
    expect(response).to redirect_to(new_user_session_path(locale: :en))
  end

  it "does not send reset instructions for a locked account" do
    existing_user = create(
      :user,
      email: "locked.user@example.com",
      account_active: false
    )
    ActionMailer::Base.deliveries.clear

    expect do
      post user_registration_path, params: {
        user: signup_attributes(email: existing_user.email)
      }
    end.not_to change { ActionMailer::Base.deliveries.count }

    expect(existing_user.reload.reset_password_token).to be_nil
    expect(response).to redirect_to(new_user_session_path(locale: :en))
  end

  def signup_attributes(email:)
    {
      first_name: "Returning",
      last_name: "User",
      email: email,
      password: "password123",
      password_confirmation: "password123"
    }
  end
end
