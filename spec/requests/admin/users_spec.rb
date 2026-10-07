require "rails_helper"

RSpec.describe "Admin user account creation", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:admin) { create(:user, :admin) }
  let!(:user_group) { UserGroup.create!(name: "University team", key: "university_team") }

  before do
    allow_any_instance_of(User).to receive(:send_admin_alert)
    allow_any_instance_of(User).to receive(:send_sonya_mail)
  end

  it "allows an administrator to create a user with a role and group" do
    sign_in admin
    expect do
      post admin_users_path, params: { user: valid_attributes.merge(send_account_email: "0") }
    end.to change(User, :count).by(1).and change(UserGroupMembership, :count).by(1)

    user = User.find_by!(email: "alex.morgan@example.com")
    expect(user.role).to eq("us_open_media")
    expect(user.user_groups).to contain_exactly(user_group)
    expect(response).to redirect_to(users_path(locale: :en))
  end

  it "sends secure setup instructions when requested" do
    sign_in admin
    expect_any_instance_of(User).to receive(:deliver_account_setup_instructions)

    post admin_users_path, params: { user: valid_attributes.merge(send_account_email: "1") }

    expect(User.find_by!(email: "alex.morgan@example.com")).to be_present
  end

  it "keeps the legacy admin flag aligned with the admin role" do
    sign_in admin

    post admin_users_path, params: { user: valid_attributes.merge(role: "admin") }

    expect(User.find_by!(email: "alex.morgan@example.com").admin).to be(true)
  end

  it "renders validation errors without creating a duplicate account" do
    existing_user = create(:user)
    sign_in admin
    expect do
      post admin_users_path, params: { user: valid_attributes.merge(email: existing_user.email) }
    end.not_to change(User, :count)

    expect(response).to have_http_status(:unprocessable_entity)
    expect(response.body).to include("Email has already been taken")
  end

  it "prevents non-admin users from accessing the form" do
    sign_in create(:user)
    get new_admin_user_path
    expect(response).to redirect_to(root_url(locale: :en))
  end

  it "allows an administrator to email a password reset link to an active user" do
    user = create(:user, email: "reset-me@example.com")
    sign_in admin
    ActionMailer::Base.deliveries.clear

    expect do
      post send_password_reset_admin_user_path(user)
    end.to change { ActionMailer::Base.deliveries.count }.by(1)

    expect(user.reload.reset_password_token).to be_present
    expect(ActionMailer::Base.deliveries.last.to).to eq(["reset-me@example.com"])
    expect(ActionMailer::Base.deliveries.last.subject).to eq("Reset your Netball America password")
    expect(response).to redirect_to(users_path(locale: :en))
    expect(flash[:notice]).to eq("Password reset email was sent to reset-me@example.com.")
  end

  it "does not email a password reset link for a locked account" do
    user = create(:user, account_active: false)
    sign_in admin
    ActionMailer::Base.deliveries.clear

    expect do
      post send_password_reset_admin_user_path(user)
    end.not_to change { ActionMailer::Base.deliveries.count }

    expect(user.reload.reset_password_token).to be_nil
    expect(response).to redirect_to(users_path(locale: :en))
    expect(flash[:alert]).to include("inactive")
  end

  it "prevents non-admin users from sending another user's reset email" do
    user = create(:user)
    sign_in create(:user)

    expect do
      post send_password_reset_admin_user_path(user)
    end.not_to change { user.reload.reset_password_token }

    expect(response).to redirect_to(root_url(locale: :en))
  end

  it "allows an administrator to link and unlink a Person profile" do
    user = create(:user, email: "work-address@example.com")
    person = create(
      :person,
      email: "personal-address@example.com",
      status: "Active"
    )
    sign_in admin

    get profile_user_path(user)
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("work-address@example.com")
    expect(response.body).to include("personal-address@example.com")

    patch update_profile_user_path(user),
          params: { user: { person_id: person.id } }

    expect(response).to redirect_to(users_path(locale: :en))
    expect(user.reload.person).to eq(person)
    expect(person.reload.user_id).to eq(user.id)

    patch update_profile_user_path(user),
          params: { user: { person_id: "" } }

    expect(response).to redirect_to(users_path(locale: :en))
    expect(user.reload.person).to be_nil
    expect(person.reload.user_id).to be_nil
  end

  it "does not allow a Person already linked to another user to be reassigned" do
    first_user = create(:user)
    second_user = create(:user)
    person = create(
      :person,
      user: first_user,
      status: "Active"
    )
    sign_in admin

    patch update_profile_user_path(second_user),
          params: { user: { person_id: person.id } }

    expect(response).to have_http_status(:unprocessable_entity)
    expect(person.reload.user).to eq(first_user)
  end

  it "prevents non-admin users from managing Person links" do
    user = create(:user)
    sign_in create(:user)

    get profile_user_path(user)

    expect(response).to redirect_to(root_url(locale: :en))
  end

  def valid_attributes
    {
      first_name: "Alex",
      last_name: "Morgan",
      email: "alex.morgan@example.com",
      password: "temporary-password-123",
      password_confirmation: "temporary-password-123",
      role: "us_open_media",
      user_group_id: user_group.id
    }
  end
end
