# spec/features/auth/user_resets_password_spec.rb
require 'rails_helper'

RSpec.feature "UserResetsPassword", type: :feature, js: true do
  scenario "user resets their password successfully" do
    user = create(:user, confirmed_at: Time.current)

    reset_password_for(user, new_password: "newpassword123")

    expect(page).to have_content("Your password has been changed successfully. You are now signed in.")
  end
end

