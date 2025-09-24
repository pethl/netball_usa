# spec/features/auth/user_confirms_email_spec.rb

require 'rails_helper'

RSpec.feature "UserConfirmsEmail", type: :feature, js: true do
  scenario "user confirms their email successfully" do
    user = create(:user, confirmed_at: nil)

    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "password123"
    click_button "Log in"

    expect(page).to have_content("You have to confirm your email address before continuing.")

    confirm_user(user) # 🔥 The magic call

    expect(page).to have_content("Your email address has been successfully confirmed.")

    # Now sign in successfully
    fill_in "Email", with: user.email
    fill_in "Password", with: "password123"
    click_button "Log in"

    expect(page).to have_content("Signed in successfully")
  end
end
