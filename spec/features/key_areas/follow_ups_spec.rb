require 'rails_helper'

RSpec.describe "Follow_ups Management", type: :feature, js: true do
  let(:admin_user) { create(:user, :admin, password: "password123") }

  scenario "Admin logs in, creates follow_ups, and logs out" do
    # Log in as an admin
    login_user(admin_user)

    # Select an existing Netball Educator from the DB (just pick any)
    educator = NetballEducator.first
    user = User.second

    visit new_follow_up_path

    # Select the educator from the dropdown dynamically
    select educator.reverse_name_school_state, from: "follow_up_netball_educator_id"
    # Select the user from the dropdown dynamically
    select user.full_name, from: "follow_up_user_id"
    select "Equipment", from: "follow_up_lead_type" 
    select "In Progress", from: "follow_up_status"

    fill_in "follow_up_action_items", with: "do some chat"
    fill_in "follow_up_sale_amount", with: "100.00"


    click_button "Save Follow Up"

    expect(page).to have_content("Follow up was successfully created.")

    # Log out using the helper
    logout_user

    
  end

  scenario "Admin fails to create Follow up without mandatory fields" do

    login_user(admin_user)

    visit new_follow_up_path

    click_button "Save Follow Up"

    expect(page).to have_content("Netball educator must be linked") # Validation errors should show
   
  end

  scenario "Admin edits an existing follow_ups successfully" do
    login_user(admin_user)
    follow_ups = create(:follow_up)

    visit edit_follow_up_path(follow_ups)

    fill_in "follow_up_sale_amount", with: "150.00"
    click_button "Save Follow Up"

    expect(page).to have_content("Follow up was successfully updated.") # adjust if needed
    expect(follow_ups.reload.sale_amount.to_f).to eq(150.00)

  end
end
