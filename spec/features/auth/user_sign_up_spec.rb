# spec/features/auth/user_sign_up_spec.rb
require 'rails_helper'

RSpec.feature "UserSignUp", type: :feature, js: true do
  scenario "user signs up successfully and can log in immediately" do
    expect {
      sign_up_user(email: "test@example.com", password: "password123", role: 2)
    }.to change(User, :count).by(1)

    user = User.find_by(email: "test@example.com")
    expect(user).not_to be_nil
    expect(user.first_name).to eq("Testy")
    expect(user.last_name).to eq("McTestface")
    expect(user.role).to eq("teamlead")
    expect(user.account_active).to be true

    # ✅ After sign-up you’re auto-signed-in and see this flash + landing
    expect(page).to have_content("Welcome! You have signed up successfully.")
    expect(page).to have_content("Please select your membership type to get started.")
    expect(page).to have_content("Club Membership")
    expect(page).to have_content("Individual Membership")

    # 🔻 Start a fresh browser session to test login explicitly
    Capybara.reset_sessions!

    visit new_user_session_path
    # Fill by name/id to avoid label text brittleness
    fill_in "user[email]",    with: "test@example.com"
    fill_in "user[password]", with: "password123"
    click_button "Log in"

    # After login you land on the same membership chooser
    expect(page).to have_content("Please select your membership type to get started.")
    expect(page).to have_content("Club Membership")
    expect(page).to have_content("Individual Membership")
  end
end


