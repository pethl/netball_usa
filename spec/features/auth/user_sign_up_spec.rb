# spec/features/auth/user_sign_up_spec.rb
require 'rails_helper'

RSpec.feature "UserSignUp", type: :feature, js: true do
  scenario "user signs up successfully and can log in after confirmation" do
    expect {
      sign_up_user(email: "test@example.com", password: "password123", role: 2)
    }.to change(User, :count).by(1)

    expect(current_path).to eq(new_user_session_path)
    expect(page).to have_content("Please check your email for confirmation details")
    
    user = User.find_by(email: "test@example.com")
    expect(user).not_to be_nil
    expect(user.first_name).to eq("Testy")       # Because helper uses "Testy"
    expect(user.last_name).to eq("McTestface")    # Because helper uses "McTestface"
    expect(user.role).to eq("teamlead")
    expect(user.account_active).to be true

    user.confirm

    visit new_user_session_path
    fill_in "Email", with: "test@example.com"
    fill_in "Password", with: "password123"
    click_button "Log in"

    expect(page).to have_content("Signed in successfully")
  end
end
