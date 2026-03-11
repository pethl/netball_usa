require "rails_helper"

RSpec.describe "Equipment Management", type: :feature, js: true do
  let(:admin_user) { create(:user, :admin, password: "password123") }
  let!(:educator) { create(:netball_educator) }

  scenario "Admin creates a sale" do
    login_user(admin_user)

    visit equipment_index_path
    click_link "New Sale"

    expect(page).to have_field("equipment_status", type: "hidden", with: "Sale")
    expect(page).to have_button("Save Equipment Sale")

    select educator.reverse_name_school_state, from: "equipment_netball_educator_id"
    fill_in "equipment_items_purchased", with: "10 Netballs"
    fill_in "equipment_purchase_amount", with: "100.00"
    fill_in "equipment_sale_date", with: "2025-04-07"

    click_button "Save Equipment Sale"

    expect(page).to have_content("Equipment was successfully created.")
    expect(page).to have_content("Sale")
    expect(page).to have_content("10 Netballs")
    expect(page).to have_content("$100.00")
    expect(page).to have_content(educator.full_name)
  end

  scenario "Admin creates a quote" do
    login_user(admin_user)

    visit equipment_index_path
    click_link "New Quote"

    expect(page).to have_field("equipment_status", type: "hidden", with: "Quote")
    expect(page).to have_button("Save Quote")

    fill_in "equipment_customer_name", with: "Pat Customer"
    fill_in "equipment_customer_email", with: "pat@example.com"
    fill_in "equipment_customer_address", with: "123 Main St"
    fill_in "equipment_items_quoted", with: "20 bibs and 10 balls"
    fill_in "equipment_quote_amount", with: "250.00"
    select educator.reverse_name_school_state, from: "equipment_netball_educator_id"

    click_button "Save Quote"

    expect(page).to have_content("Equipment was successfully created.")
    expect(page).to have_content("Quote")
    expect(page).to have_content("20 bibs and 10 balls")
    expect(page).to have_content("$250.00")
    expect(page).to have_content(educator.full_name)

    equipment = Equipment.last
    expect(equipment.customer_name).to eq("Pat Customer")
    expect(equipment.customer_email).to eq("pat@example.com")
    expect(equipment.customer_address).to eq("123 Main St")
  end

  scenario "New Sale preloads sale status" do
    login_user(admin_user)

    visit equipment_index_path
    click_link "New Sale"

    expect(page).to have_field("equipment_status", type: "hidden", with: "Sale")
    expect(page).to have_button("Save Equipment Sale")
  end

  scenario "New Quote preloads quote status" do
    login_user(admin_user)

    visit equipment_index_path
    click_link "New Quote"

    expect(page).to have_field("equipment_status", type: "hidden", with: "Quote")
    expect(page).to have_button("Save Quote")
  end

  scenario "Admin edits an existing sale successfully" do
    login_user(admin_user)

    equipment = create(:equipment, :sale, netball_educator: educator)

    visit edit_equipment_path(equipment)

    fill_in "equipment_purchase_amount", with: "100.00"
    click_button "Save Equipment Sale"

    expect(page).to have_content("Equipment was successfully updated.")
    expect(equipment.reload.purchase_amount.to_f).to eq(100.0)
  end

  scenario "Admin edits an existing quote successfully" do
    login_user(admin_user)

    equipment = create(:equipment, :quote, netball_educator: educator)

    visit edit_equipment_path(equipment)

    fill_in "equipment_quote_amount", with: "300.00"
    click_button "Save Quote"

    expect(page).to have_content("Equipment was successfully updated.")
    expect(equipment.reload.quote_amount.to_f).to eq(300.0)
  end
end