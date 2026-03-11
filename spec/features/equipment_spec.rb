require 'rails_helper'

RSpec.describe "Equipment Management", type: :feature, js: true do
  let(:admin_user) { create(:user, :admin, password: "password123") }
   let!(:educator) { create(:netball_educator) }

  scenario "Admin creates a Sale" do
    login_user(admin_user)

    visit equipment_index_path
    click_link "New Sale"

    select educator.reverse_name_school_state, from: "equipment_netball_educator_id"

    fill_in "equipment_items_purchased", with: "10 Netballs"
    fill_in "equipment_purchase_amount", with: "100.00"
    fill_in "equipment_sale_date", with: "2025-04-07"

    click_button "Save Equipment"

    expect(page).to have_content("Equipment was successfully created.")
    expect(page).to have_content("Sale")
  end

  scenario "Admin creates a Quote" do
    login_user(admin_user)

    visit equipment_index_path
    click_link "New Quote"

    fill_in "equipment_items_purchased", with: "Quote for 20 balls"
    fill_in "equipment_purchase_amount", with: "200.00"

    click_button "Save Equipment"

    expect(page).to have_content("Equipment was successfully created.")
    expect(page).to have_content("Quote")
  end

  scenario "Admin edits existing equipment" do
    login_user(admin_user)

    equipment = create(:equipment, :sale, netball_educator: educator)

    visit edit_equipment_path(equipment)

    fill_in "equipment_purchase_amount", with: "150.00"
    click_button "Save Equipment"

    expect(page).to have_content("Equipment was successfully updated.")
    expect(equipment.reload.purchase_amount.to_f).to eq(150.0)
  end

 

  scenario "Admin fails to create Equipmentwithout mandatory fields" do

    login_user(admin_user)

    visit new_equipment_path

    find("input[type='submit']").click

    expect(page).to have_content("Netball educator must exist") # Validation errors should show
   
  end

  scenario "Admin edits an existing Equipment successfully" do
    login_user(admin_user)
    equipment = create(:equipment)

    visit edit_equipment_path(equipment)

    fill_in "equipment_purchase_amount", with: "100.00"
    find("input[type='submit']").click

    expect(page).to have_content("Equipment was successfully updated.") # adjust if needed
    expect(equipment.reload.purchase_amount.to_f).to eq(100.00)

  end
end
