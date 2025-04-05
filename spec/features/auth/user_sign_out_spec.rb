# spec/features/auth/user_sign_out_spec.rb

require 'rails_helper'

RSpec.feature "UserSignOut", type: :feature, js: true do
    let!(:user) { create(:user) } # 🔵 This creates a user object
  
    before do
      login_user(user)            # 🔵 This uses the user object to log in
    end

    scenario "user signs out successfully" do

      # Click logout
      find("i.fa-arrow-right-from-bracket").click

      # Verify redirection to the logged out page
      expect(page).to have_content("You've been logged out")
      expect(page).to have_link("Sign in again")
      expect(current_path).to eq(goodbye_path) # Ensure redirected to the logged out page
    end
  end