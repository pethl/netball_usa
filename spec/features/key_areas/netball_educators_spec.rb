require 'rails_helper'

RSpec.describe "NetballEducators Management", type: :feature, js: true do
  let(:admin_user) { create(:user, :admin) }

  before do
    login_as(admin_user, scope: :user)
 # Devise Warden helper
  end

  scenario "Admin creates a new Netball Educator successfully" do
    visit new_netball_educator_path
    save_and_open_page

    # 🚀 Directly filling in field IDs
    fill_in "netball_educator_first_name", with: "Brie"
    fill_in "netball_educator_last_name", with: "Doe"
    fill_in "netball_educator_email", with: "brie.doe@example.com"
    fill_in "netball_educator_school_name", with: "Test School"
    fill_in "netball_educator_city", with: "Miami"
    find("#netball_educator_state").find("option[value='FL']").select_option
    find("#netball_educator_level").find("option[value='High']").select_option

    expect(page).to have_button("Save Educator")
    click_button "Save Educator"

   # Check that the educator was created with the correct email
   educator = NetballEducator.find_by(email: "brie.doe@example.com")
   expect(educator).not_to be_nil
   expect(educator.email).to eq("brie.doe@example.com")
   
  end

  scenario "Admin fails to create a Netball Educator without mandatory fields" do
    visit new_netball_educator_path

    click_button "Save Educator"

    expect(page).to have_content("can't be blank") # Validation errors should show
   
  end

  scenario "Admin edits an existing Netball Educator successfully" do
    educator = create(:netball_educator)

    visit edit_netball_educator_path(educator)

    fill_in "netball_educator_city", with: "New York"
    click_button "Save Educator"

    expect(page).to have_content("Educator was successfully updated.") # adjust if needed
    expect(educator.reload.city).to eq("New York")

  end
end
