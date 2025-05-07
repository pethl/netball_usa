require 'rails_helper'

RSpec.describe "Follow_ups Management", type: :feature, js: true do
  let(:admin_user) { create(:user, :admin, password: "password123") }

  scenario "Admin logs in, creates follow_ups, and logs out" do
    login_user(admin_user)

    educator = NetballEducator.first
    user = User.second

    visit new_follow_up_path

    # Select educator safely
    educator_select = find("#follow_up_netball_educator_id", visible: true)
    page.execute_script("arguments[0].scrollIntoView(true);", educator_select.native)
    educator_select.click
    select educator.reverse_name_school_state, from: "follow_up_netball_educator_id"

    # Select user safely
    user_select = find("#follow_up_user_id", visible: true)
    page.execute_script("arguments[0].scrollIntoView(true);", user_select.native)
    user_select.click
    select user.full_name, from: "follow_up_user_id"

    # Select lead_type safely
    lead_type_select = find("#follow_up_lead_type", visible: true)
    page.execute_script("arguments[0].scrollIntoView(true);", lead_type_select.native)
    lead_type_select.click
    select "Equipment", from: "follow_up_lead_type"

    # Select status safely
    status_select = find("#follow_up_status", visible: true)
    page.execute_script("arguments[0].scrollIntoView(true);", status_select.native)
    status_select.click
    select "In Progress", from: "follow_up_status"

    fill_in "follow_up_action_items", with: "do some chat"
    fill_in "follow_up_sale_amount", with: "100.00"

    click_button "Save Follow Up"

    expect(page).to have_content("Follow up was successfully created.")

    logout_user
  end

  scenario "Admin fails to create Follow up without mandatory fields" do
    login_user(admin_user)
    visit new_follow_up_path

    click_button "Save Follow Up"

    expect(page).to have_content("Lead type must be selected")
  end

  scenario "Admin edits an existing follow_ups successfully" do
    login_user(admin_user)
    follow_ups = create(:follow_up)

    visit edit_follow_up_path(follow_ups)

    fill_in "follow_up_sale_amount", with: "150.00"
    click_button "Save Follow Up"

    expect(page).to have_content("Follow up was successfully updated.")
    expect(follow_ups.reload.sale_amount.to_f).to eq(150.00)
  end
end