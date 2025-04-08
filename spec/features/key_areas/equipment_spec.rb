require 'rails_helper'

RSpec.describe "Equipment Management", type: :feature, js: true do
  let(:admin_user) { create(:user, :admin, password: "password123") }

  scenario "Admin logs in, creates equipment, and logs out" do
    # Log in as an admin
    login_user(admin_user)

    # Select an existing Netball Educator from the DB (just pick any)
    educator = NetballEducator.first

    visit new_equipment_path

    # Select the educator from the dropdown dynamically
    select educator.reverse_name_school_state, from: "equipment_netball_educator_id"

    fill_in "equipment_items_purchased", with: "10 Netballs"
    fill_in "equipment_purchase_amount", with: "100.00"
    fill_in "equipment_sale_date", with: "2025-04-07"

    click_button "Save Equipment"

    expect(page).to have_content("Equipment was successfully created.")

    # Log out using the helper
    logout_user

    # The logout is already verified in your existing tests
    expect(page).to have_content("You've been logged out")
    expect(page).to have_link("Sign in again")
  end

  scenario "Admin fails to create Equipmentwithout mandatory fields" do

    login_user(admin_user)

    visit new_equipment_path

    click_button "Save Equipment"

    expect(page).to have_content("Netball educator must exist") # Validation errors should show
   
  end

  scenario "Admin edits an existing Equipment successfully" do
    login_user(admin_user)
    equipment = create(:equipment)

    visit edit_equipment_path(equipment)

    fill_in "equipment_purchase_amount", with: "100.00"
    click_button "Save Equipment"

    expect(page).to have_content("Equipment was successfully updated.") # adjust if needed
    expect(equipment.reload.purchase_amount.to_f).to eq(100.00)

  end
end
