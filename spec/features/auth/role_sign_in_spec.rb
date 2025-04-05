# spec/features/auth/role_sign_in_spec.rb

require 'rails_helper'

RSpec.feature "RoleSignIn", type: :feature, js: true do
  User.roles.each do |role_name, _role_value|
    scenario "user with role #{role_name} can sign in and sign out" do
      user = create(:user, role: role_name)
      
      login_user(user)

      aggregate_failures "role #{role_name}" do
        expect(page).to have_content("Signed in successfully")

        # Role-specific checks
        if role_name == "admin"
          expect(page).to have_content("Management Summary")
        elsif role_name == "teamlead"
          expect(page).to have_content("Welcome to Netball America Membership")
        elsif role_name == "na_people"
          expect(page).to have_content(/Welcome|We couldn’t find your profile/i)
        else
          expect(page).to have_content(/Dashboard|Hello Handy/i)
        end

        logout_user

        expect(page).to have_content("You've been logged out")
        expect(page).to have_link("Sign in again")
        expect(current_path).to eq(goodbye_path)
      end
    end
  end
end
